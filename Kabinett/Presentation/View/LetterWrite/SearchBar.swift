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
                    .foregroundStyle(Color.black)

                TextField("Search", text: $text)
                    .foregroundStyle(.primary)

                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 8))
            .background(Color(.white))
            .clipShape(.capsule)
        }
        
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
