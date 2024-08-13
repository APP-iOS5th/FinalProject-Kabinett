//
//  UserSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/12/24.
//

import SwiftUI

struct UserSelectionView: View {
    @StateObject private var viewModel = UserSelectionViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button("완료") {
                        
                    }
                }
                .foregroundStyle(.black)
                
                HStack {
                    Text("보내는 사람")
                        .font(.system(size: 18))
                        .bold()
                    Spacer(minLength: 20)
                    Text(viewModel.fromUser)
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 24)
                
                HStack {
                    Text("받는 사람")
                        .font(.system(size: 18))
                        .bold()
                    Spacer(minLength: 35)
                    Text(viewModel.toUser)
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 40)
                
                HStack {
                    if viewModel.loginUser != nil {
                        Spacer(minLength: 100)
                        VStack {
                            SearchBar(text: $searchText)
                            if !searchText.isEmpty {
                                Divider()
                                    .padding([.leading, .trailing], 10)
                                
                                List {
                                    ForEach(viewModel.dummyUsers.filter { "\($0.kabinettNumber)".hasPrefix(searchText)}, id: \.kabinettNumber) { user in
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
                                            Spacer()
                                            Text("\(String(user.kabinettNumber).prefix(3))-\(String(user.kabinettNumber).suffix(3))")
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
                        Spacer(minLength: 90)
                        VStack {
                            Text("로그인을 하면 다른 사람에게도 편지를 \n보낼 수 있어요")
                                .font(.system(size: 13))
                                .lineSpacing(5)
                                .foregroundStyle(Color(.systemGray))
                            HStack {
                                Spacer()
                                Button("로그인 하러가기") {
                                    
                                }
                                .buttonStyle(.plain)
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
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    UserSelectionView()
}
