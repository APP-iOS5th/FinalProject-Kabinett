//
//  SignUpKabinettNumberSelectView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpKabinettNumberSelectView: View {
    @State private var selectedKabinettNumber: Int? = nil // 2. 파베로 보내기
    
    let kabinettNumbers = ["123-456", "234-567", "345-678"] // 1. 파베에서 사용되지 않은 넘버 3개 받기
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Spacer()
                Text("마음에 드는 카비넷 번호를 선택해주세요.")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundStyle(.contentPrimary)
                    .padding(.leading, 24)
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
                            .frame(width: 280, height: 54)
                            .padding(.bottom, 8)
                            
                            Button(action: {
                                selectedKabinettNumber = index
                                print("Selected Index: \(index), Selected Number: \(kabinettNumber)")
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
                            }
                        }
                    }
                }
                .padding(.leading, 24)
                Spacer()
                Button(action: {
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
                        .frame(width: 345, height: 56)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .fill(selectedKabinettNumber != nil ? Color.primary900 : Color.primary300))
                }
                .disabled(selectedKabinettNumber == nil)
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

#Preview {
    SignUpKabinettNumberSelectView()
}