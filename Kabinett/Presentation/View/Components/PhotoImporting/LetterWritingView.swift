//
//  LetterWritingView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct LetterWritingView: View {
    @EnvironmentObject var viewModel: ImagePickerViewModel
    @EnvironmentObject var customViewModel: CustomTabViewModel
    @EnvironmentObject var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var letterWriteViewModel = LetterWriteModel()
    @State private var showEnvelopeStampSelection = false
    @State private var showCalendar = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primary100.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    FormToUserView(letterContent: $letterWriteViewModel, viewModel: viewModel)
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
                leading: Button(action: {
                    letterWriteViewModel.reset()
                    viewModel.resetSelections()
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.contentPrimary)
                },
                trailing: Button(action: {
                    updateLetterWrite()
                    showEnvelopeStampSelection = true
                }) {
                    Text("완료")
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundColor(.contentPrimary)
                }
            )
            .navigationDestination(isPresented: $showEnvelopeStampSelection) {
                EnvelopeStampSelectionView(letterContent: $letterWriteViewModel)
                    .environmentObject(envelopeStampSelectionViewModel)
            }
        }
        .slideToDismiss {
            viewModel.resetSelections()
            dismiss()
        }
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
            
            if showCalendar {
                DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .frame(maxHeight: 350)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .onChange(of: viewModel.date) { _, _ in
                        showCalendar = false
                    }
            }
        }
    }
    
    private func updateLetterWrite() {
        letterWriteViewModel.fromUserName = viewModel.fromUserName
        letterWriteViewModel.toUserName = viewModel.toUserName
        letterWriteViewModel.date = viewModel.date
        letterWriteViewModel.photoContents = viewModel.photoContents
        letterWriteViewModel.dataSource = .fromImagePicker
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
