//
//  FontStylePickerView.swift
//  Kabinett
//
//  Created by Song Kim on 5/20/25.
//

import SwiftUI

struct FontStylePickerView: View {
    @Binding var letter: WriteLetter
    @ObservedObject var viewModel: ContentWriteViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.showFontEditPicker = false
                }
            
            HStack {
                Button {
                    viewModel.toggleFontMenuView()
                } label: {
                    Text("F")
                        .bold()
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: 30)
                        .background(viewModel.isFontEdit ? Color.clear : Color(.primary300))
                        .clipShape(Capsule())
                }
                .disabled(viewModel.isFontEdit ? false : true)
                
                Button {
                    // TODO: 컬러피커 넣기
                } label: {
                    Image(systemName: "pencil.tip.crop.circle")
                        .bold()
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: 30)
                }
            }
            .buttonStyle(.plain)
            .padding(7)
            .frame(width: 130, height: 60)
            .background(Color.white)
            .clipShape(Capsule())
            .padding(.top, UIScreen.main.bounds.height/1.3)
            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
        }
    }
}
