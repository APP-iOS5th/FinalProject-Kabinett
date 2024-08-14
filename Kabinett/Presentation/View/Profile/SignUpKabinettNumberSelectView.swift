//
//  SignUpKabinettNumberSelectView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpKabinettNumberSelectView: View {
    @State private var selectedKabinettNumber: Int? = nil // 2. 파베로 보내기
    @State private var shouldNavigatedToProfile = false
    
    let userName: String
    let kabinettNumbers = ["123-456", "234-567", "345-678"] // 1. 파베에서 사용되지 않은 넘버 3개 받기
    
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
                            let kabinettNumber = kabinettNumbers[index]
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
                                    selectedKabinettNumber = index
                                }) {
                                    ZStack{
                                        Circle()
                                            .foregroundColor(selectedKabinettNumber == index ? .contentPrimary : .primary300)
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
                        if selectedKabinettNumber != nil {
                            shouldNavigatedToProfile = true
                        }
                        if let selectedKabinettNumber = selectedKabinettNumber {
                            print("Tapped CTA Button. Selected Number: \(kabinettNumbers[selectedKabinettNumber])")
                        } else {
                            print("No number selected")
                        }
                    }) {
                        Text("시작하기")
                            .fontWeight(.medium)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.86, height: 56)
                            .background(RoundedRectangle(cornerRadius: 14)
                                .fill(selectedKabinettNumber != nil ? Color.primary900 : Color.primary300))
                    }
                    .disabled(selectedKabinettNumber == nil)
                    .padding(.horizontal, geometry.size.width * 0.06)
                    .navigationDestination(isPresented: $shouldNavigatedToProfile) {
                        ProfileView(userName: userName, userNumber: kabinettNumbers[selectedKabinettNumber ?? 0])
                    }
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
