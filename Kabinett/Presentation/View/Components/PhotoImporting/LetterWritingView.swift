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
    @State private var letterWriteViewModel = LetterWriteModel()
    @StateObject var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @State private var showEnvelopeStampSelection = false
    @State private var showCalendar = false
    @Environment(\.dismiss) var dismiss
    
    init(componentsLoadStuffUseCase: ComponentsLoadStuffUseCase) {
        let wrappedUseCase = LetterWriteLoadStuffUseCaseWrapper(componentsLoadStuffUseCase)
        _envelopeStampSelectionViewModel = StateObject(wrappedValue: EnvelopeStampSelectionViewModel(useCase: wrappedUseCase))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primary100.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 0) {
                        userField(title: "보내는 사람", value: $viewModel.fromUserName, search: $viewModel.fromUserSearch, isFromUser: true)
                        userField(title: "받는 사람", value: $viewModel.toUserName, search: $viewModel.toUserSearch, isFromUser: false)
                        dateField()
                        Spacer()
                    }
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 5)
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                updateLetterWriteViewModel()
                showEnvelopeStampSelection = true
            }) {
                Text("완료")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 16, weight: .medium))
            }
            )
            .navigationDestination(isPresented: $showEnvelopeStampSelection) {
                EnvelopeStampSelectionView(letterContent: $letterWriteViewModel)
                    .environmentObject(envelopeStampSelectionViewModel)
            }
        }
    }
    
    private func userField(title: String, value: Binding<String>, search: Binding<String>, isFromUser: Bool) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 10) {
                Text(title)
                    .foregroundStyle(Color.contentPrimary)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 90, alignment: .leading)
                
                TextField("", text: value)
                    .foregroundStyle(Color.contentSecondary)
                    .font(.system(size: 15))
                    .padding(.horizontal, 15)
                    .frame(height: 38)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 10) {
                Spacer()
                    .frame(width: 90)
                VStack(alignment: .leading, spacing: 0) {
                    UserSearchBar(text: search)
                        .onChange(of: search.wrappedValue) { _, newValue in
                            viewModel.searchUsers(searchText: newValue, isFromUser: isFromUser)
                        }
                    if !search.wrappedValue.isEmpty {
                        Divider()
                            .background(Color.gray)
                            .padding(.horizontal, 15)
                    }
                    ZStack(alignment: .top) {
                        Color.clear
                            .frame(height: 200)
                        
                        if !search.wrappedValue.isEmpty {
                            ScrollView {
                                VStack(spacing: 0) {
                                    Button(action: {
                                        if isFromUser {
                                            viewModel.fromUserName = search.wrappedValue
                                        } else {
                                            viewModel.toUserName = search.wrappedValue
                                        }
                                        search.wrappedValue = ""
                                    }) {
                                        HStack {
                                            Text("\(search.wrappedValue) 입력")
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 15)
                                    }
                                    
                                    ForEach(isFromUser ? viewModel.fromUserSearchResults : viewModel.toUserSearchResults, id: \.self) { userName in
                                        userSearchResultButton(userName: userName, isFromUser: isFromUser)
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(27)
                            .shadow(radius: 1)
                        }
                    }
                }
            }
        }
    }
    
    private func userSearchResultButton(userName: String, isFromUser: Bool) -> some View {
        Button(action: {
            if isFromUser {
                viewModel.fromUserName = userName
            } else {
                viewModel.toUserName = userName
            }
            viewModel.selectUser(userName, isFromUser: isFromUser)
        }) {
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text(String(userName.prefix(1)))
                            .foregroundColor(.blue)
                    )
                
                Text(userName)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("000-000")
                    .foregroundColor(.gray)
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
                    .foregroundStyle(Color.contentPrimary)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 90, alignment: .leading)
                
                Button(action: {
                    showCalendar.toggle()
                }) {
                    Text(viewModel.formattedDate)
                        .foregroundStyle(Color.blue)
                        .font(.system(size: 15))
                        .padding(.horizontal, 15)
                        .frame(height: 34)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.primary300)
                        .tint(Color.blue)
                        .cornerRadius(6)
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
                .background(Color.white)
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .onChange(of: viewModel.date) { _, _ in
                    showCalendar = false
                }
            }
        }
    }
    
    private func updateLetterWriteViewModel() {
        letterWriteViewModel.fromUserName = viewModel.fromUserName
        letterWriteViewModel.toUserName = viewModel.toUserName
        letterWriteViewModel.date = viewModel.date
        letterWriteViewModel.photoContents = viewModel.photoContents
        letterWriteViewModel.dataSource = .fromImagePicker
    }
}

struct UserSearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.contentPrimary)
            TextField("검색", text: $text)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 15)
        .frame(height: 38)
        .background(Color.white)
        .clipShape(Capsule())
    }
}
