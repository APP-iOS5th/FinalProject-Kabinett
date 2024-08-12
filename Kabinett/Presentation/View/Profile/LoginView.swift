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
            .frame(width: 104)
        Text("User")
            .fontWeight(.medium)
            .font(.system(size: 36))
        Text("000-000")
            .font(.system(size: 16))
            .monospaced()
            .foregroundStyle(.gray)
        Text("비회원 계정이에요.")
            .fontWeight(.bold)
            .font(.system(size: 16))
            .foregroundStyle(.gray)
        SignInWithAppleButton(.signIn) { request in
          
        } onCompletion: { result in

        }
        .frame(width: 345, height: 54)
    }
}

#Preview {
    LoginView()
}
