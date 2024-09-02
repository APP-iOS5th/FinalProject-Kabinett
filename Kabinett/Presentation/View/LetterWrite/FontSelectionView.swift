//
//  FontSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/17/24.
//

import SwiftUI

struct FontSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    
    @StateObject var viewModel = FontSelectionViewModel()
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            GeometryReader { geometry in
                
                VStack(alignment: .leading) {
                    NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "서체 고르기", isNavigation: true)
                    
                    List {
                        ForEach(0..<viewModel.dummyFonts.count, id: \.self) { i in
                            VStack {
                                HStack {
                                    Text("\(viewModel.dummyFonts[i].fontName)")
                                        .font(viewModel.font(file: viewModel.dummyFonts[i].regularFont))
                                    Spacer()
                                }
                                .onTapGesture {
                                    UIApplication.shared.endEditing()
                                }
                                .padding(.top, 20)
                                HStack {
                                    TextField(
                                        "",
                                        text: $viewModel.testFontText[i],
                                        prompt: Text("텍스트를 입력해보세요. Write Someting...").foregroundColor(Color.black)
                                    )
                                    .baselineOffset(viewModel.dummyFonts[i].fontName == "Pecita" ? -1 : 0)
                                    .padding(.leading, 6)
                                    .font(viewModel.font(file: viewModel.dummyFonts[i].regularFont))
                                    .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .onAppear {
                                        if letterContent.fontString == nil {
                                            letterContent.fontString = viewModel.dummyFonts[viewModel.selectedIndex].regularFont
                                        }
                                    }
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
                                .padding([.top, .bottom], 2)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(.plain)
                    
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
                                .presentationDragIndicator(.visible)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.06)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
