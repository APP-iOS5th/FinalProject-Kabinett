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
    let action: (() -> Void)?
    
    init(destination: Destination, titleName: String, isNavigation: Bool, action: (() -> Void)? = nil) {
        self.destination = destination
        self.titleName = titleName
        self.isNavigation = isNavigation
        self.action = action
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
//                        .aspectRatio(contentMode: .fit)
                        .font(.system(size: 22, weight: .semibold))
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
//                            .foregroundColor(Color.black)
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundColor(.contentPrimary)
                    }
                } else if let action = action {
                    Button("다음", action: action)
//                        .foregroundColor(Color.black)
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundColor(.contentPrimary)
                }
            }
        }
        .padding(.top, 12)
        .background(Color("Background"))
    }
}
