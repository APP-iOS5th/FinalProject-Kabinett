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
    
    var body: some View {
        HStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color("ContentPrimary"))
            }
            .padding(.leading, 24)
            
            Spacer()
            
            Text(titleName)
            
            Spacer()
            
            NavigationLink(destination: destination) {
                Text("완료")
                    .foregroundColor(Color.black)
            }
            .padding(.trailing, 24)
        }
        .padding(.top, 12)
        .background(Color("Background"))
    }
}
