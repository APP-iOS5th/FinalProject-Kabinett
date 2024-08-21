//
//  ModalTestView.swift
//  Kabinett
//
//  Created by Song Kim on 8/12/24.
//

import SwiftUI

struct ModalTestView: View {
    @State private var showModal = false
    @State var letterContent = LetterWriteViewModel()
    
    @State private var text: String = "Enter some text: "
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack {
                    NavigationLink("button") {
                        StationerySelectionView(letterContent: $letterContent)
                    }
                }
            }
        }
    }
}

#Preview {
    ModalTestView()
}
