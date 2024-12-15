//
//  LetterWritingView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import FirebaseAnalytics
import SwiftUI

struct LetterWritingView: View {
    @ObservedObject var viewModel: ImagePickerViewModel
    @ObservedObject var customViewModel: CustomTabViewModel
    @ObservedObject var envelopeStampViewModel: EnvelopeStampSelectionViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var letterContent: LetterWriteModel
    @Binding var showEnvelopeStamp: Bool
    @State private var showCalendar = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primary100.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    FormToUserView(letterContent: $letterContent, viewModel: viewModel)
                    dateField()
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                .padding(.top, 20)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarItems(
                trailing: Button(action: {
                    updateLetterWrite()
                    dismiss()
                    showEnvelopeStamp = true
                }) {
                    Text("완료")
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundColor(.contentPrimary)
                }
            )
        }
        .task {
            await viewModel.fetchCurrentWriter()
            viewModel.updateDefaultUsers()
            updateLetterWriteFromViewModel()
        }
        .analyticsScreen(
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
    }
    
    private func updateLetterWriteFromViewModel() {
        letterContent.fromUserName = viewModel.fromUserName
        letterContent.fromUserId = viewModel.fromUserId
        letterContent.toUserName = viewModel.toUserName
        letterContent.toUserId = viewModel.toUserId
        
    }
    
    private func dateField() -> some View {
        VStack(spacing: 1) {
            HStack(alignment: .center, spacing: 10) {
                Text("받은/보낸 날짜")
                    .foregroundStyle(Color.contentPrimary)
                    .bold()
                    .font(.system(size: 16))
                    .frame(width: 100, alignment: .leading)
                
                Button(action: {
                    showCalendar.toggle()
                }) {
                    Text(viewModel.formattedDate)
                        .foregroundStyle(Color.blue)
                        .font(.system(size: 15))
                        .padding(.horizontal, 15)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.contentTertiary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .sheet(isPresented: $showCalendar) {
            DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .frame(maxHeight: 350)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding()
                .presentationDetents([.height(470)])
                .presentationBackground(.clear)
                .presentationCornerRadius(5)
                .interactiveDismissDisabled()
                .onChange(of: viewModel.date) { oldValue, newValue in
                    if oldValue != newValue {
                        letterContent.date = newValue
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showCalendar = false
                        }
                    }
                }
        }
    }
    
    private func updateLetterWrite() {
        letterContent.fromUserName = viewModel.fromUserName
        letterContent.toUserName = viewModel.toUserName
        letterContent.date = viewModel.date
        letterContent.photoContents = viewModel.photoContents
        letterContent.dataSource = .fromImagePicker
    }
}

struct FormToUserView: View {
    @Binding var letterContent: LetterWriteModel
    @ObservedObject var viewModel: ImagePickerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            userField(title: "보내는 사람", name: $viewModel.fromUserName, search: $viewModel.fromUserSearch, isFromUser: true)
            userField(title: "받는 사람", name: $viewModel.toUserName, search: $viewModel.toUserSearch, isFromUser: false)
        }
        
        .onAppear {
            if let fromUser = viewModel.fromUser {
                letterContent.fromUserId = fromUser.id
                letterContent.fromUserName = fromUser.name
                viewModel.fromUserName = fromUser.name
                viewModel.fromUserKabinettNumber = fromUser.kabinettNumber
            }
            
            letterContent.toUserId = letterContent.fromUserId
            letterContent.toUserName = letterContent.fromUserName
            viewModel.toUserId = letterContent.fromUserId
            viewModel.toUserName = letterContent.fromUserName
            viewModel.toUserKabinettNumber = viewModel.fromUserKabinettNumber
        }
        
    }
    
    private func userField(title: String, name: Binding<String>, search: Binding<String>, isFromUser: Bool) -> some View {
        VStack(spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text(title)
                    .foregroundStyle(Color.contentPrimary)
                    .font(.system(size: 16))
                    .bold()
                    .frame(width: 100, alignment: .leading)
                
                TextField(isFromUser ? name.wrappedValue : "", text: name)
                    .foregroundStyle(isFromUser ? Color.contentSecondary : .black)
                    .font(.system(size: 15))
                    .padding(.horizontal, 15)
                    .frame(height: 40)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .multilineTextAlignment(.center)
            }
            
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                    .frame(width: 100)
                
                SearchResultList(letterContent: $letterContent, searchText: search, viewModel: viewModel, isFromUser: isFromUser)
            }
        }
    }
    
    struct SearchResultList: View {
        @Binding var letterContent: LetterWriteModel
        @Binding var searchText: String
        @ObservedObject var viewModel: ImagePickerViewModel
        let isFromUser: Bool
        
        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.contentPrimary)
                    
                    TextField("검색", text: $searchText)
                        .foregroundStyle(.primary)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.primary100)
                        }
                    }
                }
                .padding(EdgeInsets(top: 7, leading: 13, bottom: 7, trailing: 13))
                .background(Color(.white))
                .clipShape(.capsule)
                
                if !searchText.isEmpty {
                    Divider()
                        .padding([.leading, .trailing], 10)
                        .padding(.top, -6)
                    
                    List {
                        Text("\(searchText) 입력")
                            .onTapGesture {
                                updateUser(name: searchText)
                                searchText = ""
                                UIApplication.shared.endEditing()
                            }
                            .padding(.leading, 35)
                            .listRowSeparator(.hidden)
                            .foregroundStyle(Color.primary900)
                        
                        ForEach(isFromUser ? viewModel.fromUserSearchResults : viewModel.toUserSearchResults, id: \.name) { user in
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(.circle)
                                    .foregroundStyle(Color.primary100)
                                Text(user.name)
                                    .foregroundStyle(Color.primary900)
                                Spacer()
                                Text("\(String(user.kabinettNumber.prefix(3)))-\(String(user.kabinettNumber.suffix(3)))")
                                    .foregroundStyle(Color.primary900)
                            }
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                updateUser(name: user.name)
                                searchText = ""
                                UIApplication.shared.endEditing()
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 200)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.top, -5)
                }
            }
            .padding(.top, 2)
            .background(searchText.isEmpty ? Color.clear : Color.white)
            .cornerRadius(16)
        }
        
        private func updateUser(name: String) {
            if isFromUser {
                viewModel.fromUserName = name
                letterContent.fromUserName = name
                if let user = viewModel.usersData.first(where: { $0.name == name }) {
                    letterContent.fromUserId = user.id
                    viewModel.fromUserKabinettNumber = user.kabinettNumber
                }
            } else {
                viewModel.updateSelectedUser(selectedUserName: name)
            }
        }
    }
}
