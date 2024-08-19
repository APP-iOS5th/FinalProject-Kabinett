//
//  UserSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/12/24.
//

import SwiftUI

struct UserSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var viewModel = UserSelectionViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button("완료") {
                            letterContent.toUserId = viewModel.toUser
                            letterContent.fromUserId = viewModel.fromUser
                            presentation.wrappedValue.dismiss()
                        }
                    }
                    .foregroundStyle(.black)
                    
                    HStack {
                        Text("보내는 사람")
                            .foregroundStyle(Color("ContentPrimary"))
                            .font(.system(size: 16))
                            .bold()
                        Spacer(minLength: 22)
                        Text(viewModel.fromUser)
                            .foregroundStyle(Color("ContentSecondary"))
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, minHeight: 35)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 24)
                    
                    HStack {
                        Text("받는 사람")
                            .foregroundStyle(Color("ContentPrimary"))
                            .font(.system(size: 16))
                            .bold()
                        Spacer(minLength: 37)
                        Text(viewModel.toUser)
                            .foregroundStyle(viewModel.toUser == "나" ? Color("ContentSecondary") : Color.black)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, minHeight: 35)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 40)
                    
                    HStack {
                        if viewModel.checkLogin {
                            Spacer(minLength: 100)
                            VStack {
                                SearchBar(text: $searchText)
                                if !searchText.isEmpty {
                                    Divider()
                                        .padding([.leading, .trailing], 10)
                                    
                                    List {
                                        Text("\(searchText) 입력")
                                            .onTapGesture {
                                                viewModel.toUser = searchText
                                                searchText = ""
                                            }
                                            .padding(.leading, 35)
                                            .listRowSeparator(.hidden)
                                            .foregroundStyle(Color("Primary900"))
                                        
                                        ForEach(viewModel.dummyData.dummyUsers.filter { user in
                                            user.name.lowercased().contains(searchText.lowercased()) ||
                                            String(format: "%06d", user.kabinettNumber).hasPrefix(searchText)
                                        }, id: \.kabinettNumber) { user in
                                            HStack {
                                                if let profileImage = user.profileImage {
                                                    AsyncImage(url: URL(string: profileImage)) { image in
                                                        image
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                            .clipShape(.circle)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                } else {
                                                    Image(systemName: "person.crop.circle")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                        .clipShape(.circle)
                                                        .foregroundStyle(Color.background)
                                                }
                                                Text(user.name)
                                                    .foregroundStyle(Color("Primary900"))
                                                Spacer()
                                                let formattedKabinettNumber = String(format: "%06d", user.kabinettNumber)
                                                Text("\(String(formattedKabinettNumber.prefix(3)))-\(String(formattedKabinettNumber.suffix(3)))")
                                                    .foregroundStyle(Color("Primary900"))
                                            }
                                            .listRowSeparator(.hidden)
                                            .onTapGesture {
                                                viewModel.toUser = user.name
                                                searchText = ""
                                            }
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    .frame(height: 200)
                                }
                            }
                            .padding(.top, 2)
                            .background(searchText.isEmpty ? Color.clear : Color.white)
                            .cornerRadius(16)
                        } else {
                            Spacer(minLength: 65)
                            VStack {
                                Text("로그인을 하면 다른 사람에게도 편지를 \n보낼 수 있어요")
                                    .font(.system(size: 12))
                                    .lineSpacing(5)
                                    .foregroundStyle(Color("ContentSecondary"))
                                    .bold()
                                HStack {
                                    Spacer()
                                    Button("로그인하기") {
                                        
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundStyle(Color("ContentPrimary"))
                                    .font(.system(size: 13))
                                    .bold()
                                    .underline()
                                    .padding(.top, 20)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.top, 1)
                    Spacer()
                }
                .padding([.leading, .trailing, .top], 24)
                .background(Color("Primary100"))
            }
        }
    }
}
