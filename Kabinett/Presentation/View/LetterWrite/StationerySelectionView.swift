//
//  StationerySelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import SwiftUI

struct StationerySelectionView: View {
    @State private var showModal = true
    @Binding var letterContent: LetterViewModel

    var body: some View {
        ZStack {
            Color(.background)
            
        }
        .ignoresSafeArea()
        .sheet(isPresented: self.$showModal) {
            UserSelectionView(letterContent: $letterContent)
                .presentationDetents([.medium, .large])
        }
    }
}

//#Preview {
//    StationerySelectionView()
//}
