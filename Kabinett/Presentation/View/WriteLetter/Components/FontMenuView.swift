//
//  CustomFontMenu.swift
//  Kabinett
//
//  Created by Song Kim on 1/6/25.
//

import SwiftUI

struct FontMenuView: View {
    @Binding var letter: WriteLetter
    @ObservedObject var viewModel: ContentWriteViewModel
    @ObservedObject var fontViewModel: FontSelectionViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.showFontMenu = false
                }
            
            VStack(spacing: 0) {
                ForEach(0..<fontViewModel.dummyFonts.count, id: \.self) { i in
                    Button(action: {
                        fontViewModel.selectedIndex = i
                        letter.fontString = fontViewModel.dummyFonts[i].font
                        viewModel.showFontMenu = false
                        viewModel.showFontEditPicker = false
                    }) {
                        HStack {
                            Text(fontViewModel.dummyFonts[i].fontName)
                                .font(FontUtility.selectedFont(font: fontViewModel.dummyFonts[i].font, size: 15))
                            
                            Spacer()
                            
                            if fontViewModel.selectedIndex == i {
                                Image("checked")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .padding(13)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(7)
            .frame(width: 250)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top, (UIScreen.main.bounds.height/1.3 - 400))
            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
        }
    }
}
