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
            
            VStack(alignment: .leading) {
                NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "폰트 고르기")
                
                List {
                    ForEach(0..<viewModel.dummyFonts.count, id: \.self) { i in
                        VStack {
                            HStack {
                                Text("\(viewModel.dummyFonts[i].fontName)")
                                    .font(viewModel.font(file: viewModel.dummyFonts[i].regularFont))
                                    .padding(.leading, 3)
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
                                .font(viewModel.font(file: viewModel.dummyFonts[i].regularFont))
                                .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                Button {
                                    viewModel.selectedIndex = i
                                    letterContent.fontString = viewModel.dummyFonts[i].regularFont
                                } label: {
                                    if letterContent.fontString == nil {
                                        Image(i == viewModel.selectedIndex ? "checked" : "unchecked")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .padding([.leading], 5)
                                    } else {
                                        Image(viewModel.dummyFonts[i].regularFont == letterContent.fontString ? "checked" : "unchecked")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .padding([.leading], 5)
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.leading, 5)
                .frame(maxWidth: .infinity, alignment: .top)
                
                HStack {
                    Button {
                        viewModel.showModal = true
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color("Primary900"))
                    }
                    .sheet(isPresented: $viewModel.showModal) {
                        OpenSourceLicenseModalView()
                            .presentationDetents([.height(280)])
                    }
                    .padding(.leading, 24)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}
