//
//  LetterWritingView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct LetterWritingView: View {
    @ObservedObject var viewModel: ImagePickerViewModel
    @State private var showDatePicker = false
    @Environment(\.dismiss) var dismiss
    
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
            .navigationBarItems(trailing: Button("완료") {
                dismiss()
            })
        }
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
                        // 검색결과
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(isFromUser ? viewModel.fromUserSearchResults : viewModel.toUserSearchResults) { writer in
                                    userSearchResultButton(writer: writer, isFromUser: isFromUser)
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
    
    private func userSearchResultButton(writer: Writer, isFromUser: Bool) -> some View {
        Button(action: {
            if isFromUser {
                viewModel.fromUserName = writer.name
                viewModel.fromUserSearch = ""
            } else {
                viewModel.toUserName = writer.name
                viewModel.toUserSearch = ""
            }
            viewModel.selectUser(writer, isFromUser: isFromUser)
        }) {
            VStack(alignment: .leading) {
                HStack {
                    if let profileImage = writer.profileImage {
                        Image(profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                    
                    Text(writer.name)
                        .foregroundColor(.primary)
                        .font(.system(size: 14, weight: .medium))
                    Text("\(writer.kabinettNumber)")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
        }
        .background(Color.white)
    }
    
    private func dateField() -> some View {
        HStack(spacing: 10) {
            Text("받을/보낼 날짜")
                .foregroundStyle(Color("ContentPrimary"))
                .font(.system(size: 16, weight: .bold))
                .frame(width: 90, alignment: .leading)
            
            Button(action: {
                showDatePicker = true
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
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(width: 350, height: 330)
            }
            .presentationDetents([.height(450)])
            .presentationDragIndicator(.visible)
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
