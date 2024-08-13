//
//  SignUpNameInputView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpNameInputView: View {
    @State private var UserName = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("이름을 알려주세요.")
                .fontWeight(.regular)
                .font(.system(size: 16))
                .foregroundStyle(.contentPrimary)
            TextField("", text: $UserName)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    SignUpNameInputView()
}
