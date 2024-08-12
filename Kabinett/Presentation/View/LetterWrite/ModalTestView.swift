//
//  ModalTestView.swift
//  Kabinett
//
//  Created by Song Kim on 8/12/24.
//

import SwiftUI

struct ModalTestView: View {
    @State private var showModal = false
    
    var body: some View {
        VStack {
            Button("modal") {
                self.showModal = true
            }
            .sheet(isPresented: self.$showModal) {
                UserSelectionView()
                    .presentationDetents([.medium, .large])
            }
        }
        .padding()
    }
}

#Preview {
    ModalTestView()
}

