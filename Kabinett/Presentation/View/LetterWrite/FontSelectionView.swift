//
//  FontSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/17/24.
//

import SwiftUI

struct FontSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel = FontSelectionViewModel()
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            List {
                ForEach(0..<viewModel.dummyFonts.count, id: \.self) { i in
                    VStack {
                        HStack {
                            Text("\(viewModel.dummyFonts[i].fontName)")
                                .font(viewModel.dummyFonts[i].fileName)
                                .padding(.leading, 5)
                                .padding(.top, 3)
                            Spacer()
                        }
                        HStack {
                            TextField(
                                "",
                                text: $viewModel.testFontText[i],
                                prompt: Text("텍스트를 입력해보세요. Write Someting...").foregroundColor(Color.black)
                            )
                            .padding(.leading, 4)
                            .font(viewModel.dummyFonts[i].fileName)
                            .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            Button {
                                viewModel.selectedIndex = i
                                letterContent.fontString = "\(viewModel.dummyFonts[i].fileName)"
                            } label: {
                                Image(viewModel.isSelected(index: i) ? "checked" : "unchecked")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .padding(5)
                            }
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("폰트 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("ContentPrimary"))
                }
                .padding(.leading, 8)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("완료") {
                    
                }
                .foregroundStyle(Color.black)
                .padding(.trailing, 8)
            }
        }
        .toolbarBackground(Color("Background"), for: .navigationBar)
    }
}
