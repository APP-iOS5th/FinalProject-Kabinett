//
//  SignUpNameInputView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpNameInputView: View {
    @StateObject var viewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss
    @State private var shouldNavigate = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack{
                VStack(alignment: .leading){
                    Text("이름을 알려주세요.")
                        .fontWeight(.regular)
                        .font(.system(size: 16))
                        .foregroundStyle(.contentPrimary)
                        .padding(.leading, geometry.size.width * 0.06)
                        .padding(.bottom, 15)
                    HStack{
                        TextField("", text: $viewModel.userName)
                            .padding(.leading, geometry.size.width * 0.06)
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
                            .padding(.trailing, geometry.size.width * 0.06)
                        }
                    }
                    .textFieldStyle(SignUpOvalTextFieldStyle(width: geometry.size.width * 0.72))
                    .font(Font.system(size: 24, design: .default))
                    .autocorrectionDisabled(true)
                    .keyboardType(.alphabet)
                    .submitLabel(.done)
                    .navigationDestination(isPresented: $shouldNavigate) {
                        SignUpKabinettNumberSelectView(viewModel: viewModel)
                    }
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.primary900)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .ignoresSafeArea(.keyboard)
            }
        }
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

#Preview {
    SignUpNameInputView(viewModel: SignUpViewModel(useCase: SignUpUseCaseStub()))
}
