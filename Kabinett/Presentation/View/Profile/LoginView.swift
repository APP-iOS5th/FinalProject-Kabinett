//
//  LoginView.swift
//  Kabinett
//
//  Created by Yule on 8/12/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        TabView{
            VStack{
                Circle()
                    .foregroundColor(.primary300)
                    .frame(width: 110)
                    .padding(.bottom, -1)
                Text("User")
                    .fontWeight(.regular)
                    .font(.system(size: 36))
                Text("000-000")
                    .fontWeight(.light)
                    .font(.system(size: 16))
                    .monospaced()
                    .padding(.bottom, 15)
                Text("비회원 계정이에요.")
                    .fontWeight(.black)
                    .font(.system(size: 19))
                    .foregroundStyle(.contentSecondary)
                    .padding(.bottom, 21)
                SignInWithAppleButton(.signIn) { request in
                    
                } onCompletion: { result in
                    
                }
                .frame(width: 345, height: 54)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            }
        }
    }


#Preview {
    LoginView()
}
