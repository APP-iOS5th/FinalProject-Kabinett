//
//  SignUpKabinettNumberSelectView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpKabinettNumberSelectView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @State private var shouldNavigatedToProfile = false
    
    var body: some View {
        NavigationView{
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
                        ForEach(0..<3, id: \.self) { index in
                            let kabinettNumber = viewModel.kabinettNumbers[index]
                            HStack{
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .stroke(Color.primary300, lineWidth: 1)
                                        .background(Capsule().fill(Color.white))
                                    Text(kabinettNumber)
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
                    }
                    .padding(.leading, geometry.size.width * 0.06)
                    Spacer()
                    Button(action: {
//                        if viewModel.selectedKabinettNumber != nil {
//                            shouldNavigatedToProfile = true
                            print("UserName: \(viewModel.userName)")
                            if let selectedNumber = viewModel.selectedKabinettNumber {
                                print("Selected Kabinett Number: \(viewModel.kabinettNumbers[selectedNumber])")
                            }
//                        }
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
//                    .navigationDestination(isPresented: $shouldNavigatedToProfile) {
//                        ProfileView(userName: userName, userNumber: kabinettNumbers[selectedKabinettNumber ?? 0])
//                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
        }
    }
}

//#Preview {
//    SignUpKabinettNumberSelectView()
//}
