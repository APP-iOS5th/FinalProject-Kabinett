//
//  CustomProgressView.swift
//  Kabinett
//
//  Created by T0MA on 10/3/24.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            Image("CustomProgressView")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(17)
        }
    }
}

#Preview {
    CustomProgressView()
}
