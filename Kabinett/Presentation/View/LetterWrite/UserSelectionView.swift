//
//  UserSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/12/24.
//

import SwiftUI

struct UserSelectionView: View {
    @State var checkLogin = false
    
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
                    Button("Song(나)") {
                        
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, minHeight: 35)
                    .background(Color.white)
                    .clipShape(.capsule)
                }
                .padding(.top, 24)
                
                HStack {
                    Text("받는 사람")
                        .font(.system(size: 18))
                        .bold()
                    Spacer(minLength: 35)
                    Button("Song(나)") {
                        
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, minHeight: 35)
                    .background(Color.white)
                    .clipShape(.capsule)
                }
                .padding(.top, 40)
                
                HStack {
                    if !checkLogin {
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
                    } else {
                        Spacer(minLength: 102)
                        Button {
                            
                        } label: {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                            Spacer(minLength: 208)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(Color.white)
                        .clipShape(.capsule)
                    }
                }
                .padding(.top, 1)
                Spacer()
            }
            .padding([.leading, .trailing, .top], 24)
        }
        .background(Color(.systemGray5))
    }
}

#Preview {
    UserSelectionView()
}
