//
//  SignUpKabinettNumberSelectView.swift
//  Kabinett
//
//  Created by Yule on 8/13/24.
//

import SwiftUI

struct SignUpKabinettNumberSelectView: View {
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("마음에 드는 카비넷 번호를 선택해주세요.")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundStyle(.contentPrimary)
                    .padding(.leading, 24)
                    .padding(.bottom, 5)
                VStack{
                    ForEach(0..<3) { _ in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .stroke(Color.primary300, lineWidth: 1)
                                .background(Capsule().fill(Color.white))
                            Text("000-000")
                                .fontWeight(.light)
                                .font(.system(size: 20))
                                .monospaced()
                                .foregroundStyle(.contentPrimary)
                                .padding(.leading, 8)
                                .padding(10)
                        }
                        .frame(width: 280, height: 54)
                    }
                }
                .padding(.leading, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

#Preview {
    SignUpKabinettNumberSelectView()
}
