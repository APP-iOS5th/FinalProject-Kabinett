//
//  SignUpKabinettNumberSelectView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpKabinettNumberSelectView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Spacer()
                Text("마음에 드는 카비넷 번호를 선택해주세요.")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundStyle(.contentPrimary)
                    .padding(.leading, geometry.size.width * 0.06)
                    .padding(.bottom, 15)
                
                VStack{
                    if viewModel.availablekabinettNumbers.count >= 3 {
                        ForEach(0..<3, id: \.self) { index in
                            let availablekabinettNumber = viewModel.availablekabinettNumbers[index]
                            HStack{
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .stroke(Color.primary300, lineWidth: 1)
                                        .background(Capsule().fill(Color.white))
                                    Text(availablekabinettNumber)
                                        .fontWeight(.light)
                                        .font(.system(size: 20))
                                        .monospaced()
                                        .foregroundStyle(.contentPrimary)
                                        .padding(.leading, 8)
                                        .padding(10)
                                }
                                .frame(width: geometry.size.width * 0.72, height: 54)
                                .padding(.bottom, 8)
                                
                                Button(action: {
                                    viewModel.selectedKabinettNumber = index
                                }) {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(viewModel.selectedKabinettNumber == index ? .contentPrimary : .primary300)
                                            .frame(width: 53)
                                        Image(systemName: "checkmark")
                                            .fontWeight(.light)
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.bottom, 8)
                                }
                            }
                        }
                    } else {
                        Text("No available Kabinett numbers.")
                            .foregroundColor(.alert)
                    }
                }
                .padding(.leading, geometry.size.width * 0.06)
                Spacer()
                Button(action: {
                    Task {
                        if let selectedIndex = viewModel.selectedKabinettNumber {
                            let selectedKabinettNumber = viewModel.availablekabinettNumbers[selectedIndex]
                            
                            let success = await viewModel.startLoginUser(
                                with: viewModel.userName,
                                kabinettNumber: selectedKabinettNumber
                            )
                            
                            if success {
                                viewModel.showSignUpFlow = false
                            } else {
                                viewModel.signUpError = "회원 가입에 실패했어요. 다시 시도해주세요."
                                viewModel.showAlert = true
                            }
                        }
                    }
                }) {
                    Text("시작하기")
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.86, height: 56)
                        .background(RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.selectedKabinettNumber != nil ? Color.primary900 : Color.primary300))
                }
                .disabled(viewModel.selectedKabinettNumber == nil)
                .padding(.horizontal, geometry.size.width * 0.06)
                .alert(
                    "오류",
                    isPresented: $viewModel.showAlert
                ) {
                    Button("확인", role: .cancel) {
                    }
                } message: {
                    Text(viewModel.signUpError ?? "회원 가입 오류가 발생했어요. 카비넷 팀에게 알려주세요.")
                }
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
        }
        .task {
            await viewModel.getNumbers()
        }
    }
}

//#Preview {
//    SignUpKabinettNumberSelectView()
//}
