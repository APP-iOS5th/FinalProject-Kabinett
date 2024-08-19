//
//  ImagePreview.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct ImagePreivew: View {
    @Binding var showActionSheet: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ImagePickerViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    // OverlappingImagesView
                    Spacer()
                    Button(action: {
                    // LetterWritingView
                    }) {
                        Text("편지 선택하기")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .navigationBarItems(leading: Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showActionSheet = true
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
            .navigationBarTitle("", displayMode: .inline)
            .background(Color("Background").edgesIgnoringSafeArea(.all))
        }
    }
}
