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
                    Button(viewModel.fromUser) {
                        
                    }
                    .buttonStyle(.plain)
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
                    Button(viewModel.toUser) {
                        
                    }
                    .buttonStyle(.plain)
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
                                    ForEach(viewModel.dummyUsers.filter { "\($0.ID)".hasPrefix(searchText) }, id: \.ID) { user in
                                        HStack {
                                            Text(user.name)
                                            Spacer()
                                            Text("\(String(user.ID).prefix(3))-\(String(user.ID).suffix(3))")
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
                        .background(searchText.isEmpty ? Color.clear : Color.white)
                        .cornerRadius(20)
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
                                    // Login action
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
