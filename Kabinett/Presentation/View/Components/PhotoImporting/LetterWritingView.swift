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
    @State private var showEnvelopeStampSelection = false
    @State private var showCalendar = false
    @Environment(\.dismiss) var dismiss
    @State private var letterWriteViewModel = LetterWriteViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Primary100").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        userField(title: "보내는 사람", value: $viewModel.fromUserName, search: $viewModel.fromUserSearch, isFromUser: true)
                        userField(title: "받는 사람", value: $viewModel.toUserName, search: $viewModel.toUserSearch, isFromUser: false)
                        dateField()
                        Spacer()
                    }
                    .padding([.leading, .trailing], 24)
                    .padding(.top, 20)
                }
            }
            .navigationBarItems(trailing: Button("다음") {
                updateLetterWriteViewModel()
                showEnvelopeStampSelection = true
            })
            .navigationDestination(isPresented: $showEnvelopeStampSelection) {
                EnvelopeStampSelectionView(letterContent: $letterWriteViewModel)
                    .environmentObject(viewModel)
            }
        }
    }
    private func updateLetterWriteViewModel() {
        letterWriteViewModel.fromUserName = viewModel.fromUserName
        letterWriteViewModel.toUserName = viewModel.toUserName
        letterWriteViewModel.date = viewModel.date
        letterWriteViewModel.photoContents = viewModel.photoContents.map { $0.base64EncodedString() }
        
        print("Updated LetterWriteViewModel:")
        print("From: \(letterWriteViewModel.fromUserName)")
        print("To: \(letterWriteViewModel.toUserName)")
        print("Date: \(letterWriteViewModel.date)")
        print("Photo contents count: \(letterWriteViewModel.photoContents.count)")
    }
    
    private func userField(title: String, value: Binding<String>, search: Binding<String>, isFromUser: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text(title)
                    .foregroundStyle(Color("ContentPrimary"))
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 90, alignment: .leading)
                
                TextField("", text: value)
                    .foregroundStyle(Color("ContentSecondary"))
                    .font(.system(size: 15))
                    .padding(.horizontal, 15)
                    .frame(height: 40)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 10) {
                Spacer()
                    .frame(width: 90)
                VStack(alignment: .leading, spacing: 0) {
                    UserSearchBar(text: search)
                    
                    if !search.wrappedValue.isEmpty {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(isFromUser ? viewModel.fromUserSearchResults : viewModel.toUserSearchResults, id: \.self) { userName in
                                    userSearchResultButton(userName: userName, isFromUser: isFromUser)
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    }
                }
            }
        }
    }
    
    private func userSearchResultButton(userName: String, isFromUser: Bool) -> some View {
        Button(action: {
            if isFromUser {
                viewModel.fromUserName = userName
                viewModel.fromUserSearch = ""
            } else {
                viewModel.toUserName = userName
                viewModel.toUserSearch = ""
            }
            viewModel.selectUser(userName, isFromUser: isFromUser)
        }) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                Text(userName)
                    .foregroundColor(.primary)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
        }
        .background(Color.white)
    }
    
    private func dateField() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text("받을/보낼 날짜")
                    .foregroundStyle(Color("ContentPrimary"))
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 90, alignment: .leading)
                
                Button(action: {
                    showCalendar.toggle()
                }) {
                    Text(viewModel.formattedDate)
                        .foregroundStyle(Color("ContentSecondary"))
                        .font(.system(size: 15))
                        .padding(.horizontal, 15)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
            }
            
            if showCalendar {
                DatePicker(
                    "",
                    selection: $viewModel.date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .frame(maxHeight: 400)
                .background(Color("Primary600"))
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .onChange(of: viewModel.date) { _, _ in
                    showCalendar = false
                }
            }
        }
    }
}

struct UserSearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("ContentPrimary"))
            TextField("검색", text: $text)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 15)
        .frame(height: 40)
        .background(Color.white)
        .clipShape(Capsule())
    }
}
