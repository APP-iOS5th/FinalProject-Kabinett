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
        ZStack {
            Color("Background")
            
            VStack {
                Button("modal") {
                    self.showModal = true
                }
                .sheet(isPresented: self.$showModal) {
                    UserSelectionView()
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ModalTestView()
}

