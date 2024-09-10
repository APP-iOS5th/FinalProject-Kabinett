//
//  SignUpNameInputView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpNameInputView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @State private var shouldNavigate = false
    let horizontalPadding: CGFloat = UIScreen.main.bounds.width * 0.06
    
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack(alignment: .leading){
                Text("이름을 알려주세요.")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundStyle(.contentPrimary)
                    .padding(.leading, horizontalPadding)
                    .padding(.bottom, 15)
                HStack{
                    TextField("", text: $viewModel.userName)
                        .padding(.leading, horizontalPadding)
                    Spacer()
                    
                    Button(action: {
                        if !viewModel.userName.isEmpty {
                            shouldNavigate = true
                        }
                    }) {
                        ZStack{
                            Circle()
                                .foregroundColor(viewModel.userName.isEmpty ? .primary300 : .primary900)
                                .frame(width: 53)
                            Image(systemName: "arrow.right")
                                .fontWeight(.light)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, horizontalPadding)
                    }
                }
                .textFieldStyle(SignUpOvalTextFieldStyle(width: UIScreen.main.bounds.width * 0.72))
                .font(Font.system(size: 24, design: .default))
                .autocorrectionDisabled(true)
                .keyboardType(.alphabet)
                .submitLabel(.done)
                .navigationDestination(isPresented: $shouldNavigate) {
                    SignUpKabinettNumberSelectView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarBackButtonHidden()
    }
}

struct SignUpOvalTextFieldStyle: TextFieldStyle {
    var width: CGFloat
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 8)
            .padding(10)
            .background(
                Capsule()
                    .stroke(Color.primary300, lineWidth: 1)
                    .background(Capsule().fill(Color.white))
            )
            .frame(width: width, height: 54)
    }
}

//#Preview {
//    SignUpNameInputView(signUpViewModel: SignUpViewModel(signUpUseCase: SignUpUseCaseStub()))
//
