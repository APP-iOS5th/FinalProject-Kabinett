//
//  SignUpKabinettNumberSelectView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpKabinettNumberSelectView: View {
    @StateObject var viewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss
    @State private var shouldNavigatedToProfile = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
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
                                
                                print("UserName: \(viewModel.userName)")
                                print("Selected Kabinett Number: \(selectedKabinettNumber)")
                                
                                let success = await viewModel.startLoginUser(
                                    with: viewModel.userName,
                                    kabinettNumber: selectedKabinettNumber
                                )
                                if success {
                                    shouldNavigatedToProfile = true
                                } else {
                                    alertMessage = "회원가입에 실패했습니다."
                                    showAlert = true
                                }
                            }
                        }
                    }) {
                        Text("시작하기")
                            .fontWeight(.medium)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.86, height: 56)
                            .background(RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.selectedKabinettNumber != nil ? Color.primary900 : Color.primary300))
                    }
                    .disabled(viewModel.selectedKabinettNumber == nil)
                    .padding(.horizontal, geometry.size.width * 0.06)
                    .alert(
                        "오류",
                        isPresented: $showAlert
                    ) {
                        Button("확인", role: .cancel) {
                        }
                    } message: {
                        Text(alertMessage)
                    }

                    .navigationDestination(isPresented:$shouldNavigatedToProfile) {
                        ProfileView(
                            viewModel: ProfileSettingsViewModel(profileUseCase: ProfileUseCaseStub())
                        )
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
            }
            .task {
                await viewModel.getNumbers()
            }
        }
    }
}

//#Preview {
//    SignUpKabinettNumberSelectView()
//}
