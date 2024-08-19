//
//  SearchBar.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color("ContentPrimary"))

                TextField("", text: $text)
                    .foregroundStyle(.primary)

                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color("Primary100"))
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 7, leading: 13, bottom: 7, trailing:13))
            .background(Color(.white))
            .clipShape(.capsule)
        }
        
    }
}
