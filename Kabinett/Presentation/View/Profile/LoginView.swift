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
        Circle()
            .foregroundColor(.gray)
            .frame(width: 110)
            .padding(.bottom, 3)
        Text("User")
            .fontWeight(.regular)
            .font(.system(size: 36))
            .padding(.bottom, 1)
        Text("000-000")
            .fontWeight(.light)
            .font(.system(size: 16))
            .monospaced()
            .foregroundStyle(.black)
            .padding(.bottom, 2)
        Text("비회원 계정이에요.")
            .fontWeight(.bold)
            .font(.system(size: 17))
            .foregroundStyle(.gray)
            .padding(.bottom, 25)
        SignInWithAppleButton(.signIn) { request in
          
        } onCompletion: { result in

        }
        .frame(width: 345, height: 54)
    }
}

#Preview {
    LoginView()
}
