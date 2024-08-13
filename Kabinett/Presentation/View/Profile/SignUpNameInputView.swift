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
        NavigationView{
            VStack(alignment: .leading){
                Text("이름을 알려주세요.")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundStyle(.contentPrimary)
                    .padding(.leading, 24)
                    .padding(.bottom, 5)
                HStack{
                    TextField("", text: $UserName)
                        .padding(.leading, 24)
                    Spacer()
                    NavigationLink(destination: SignUpKabinettNumberSelectView()) {
                        ZStack{
                            Circle()
                                .foregroundColor(.primary300)
                                .frame(width: 53)
                            Image(systemName: "arrow.right")
                                .fontWeight(.light)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                            .padding(.trailing, 24)
                    }
                }
                .textFieldStyle(OvalTextFieldStyle())
                .font(Font.system(size: 24, design: .default))
                .autocorrectionDisabled(true)
                .keyboardType(.alphabet)
                .submitLabel(.done)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 8)
            .padding(10)
            .background(
            Capsule()
                .stroke(Color.primary300, lineWidth: 1)
                .background(Capsule().fill(Color.white))
            )
            .frame(width: 280, height: 54)
    }
}

#Preview {
    SignUpNameInputView()
}
