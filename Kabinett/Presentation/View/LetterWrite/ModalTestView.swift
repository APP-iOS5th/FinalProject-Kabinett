//
//  ModalTestView.swift
//  Kabinett
//
//  Created by Song Kim on 8/12/24.
//

import SwiftUI

struct ModalTestView: View {
    @State private var showModal = false
    @State var letterContent = LetterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                VStack {
                    NavigationLink("button") {
                        StationerySelectionView(letterContent: $letterContent)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ModalTestView()
}

