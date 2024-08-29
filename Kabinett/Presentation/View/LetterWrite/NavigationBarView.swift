//
//  NavigationBarView.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import SwiftUI

struct NavigationBarView<Destination: View>: View {
    @Environment(\.presentationMode) var presentationMode
    let destination: Destination
    let titleName: String
    let isNavigation: Bool

    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("ContentPrimary"))
                }
                Spacer()
            }

            Text(titleName)
                .font(.system(size: 16, weight: .semibold))
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }

            HStack {
                Spacer()

                if isNavigation {
                    NavigationLink(destination: destination) {
                        Text("다음")
                            .foregroundColor(Color.black)
                    }
                }
            }
        }
        .padding(.top, 12)
        .background(Color("Background"))
    }
}
