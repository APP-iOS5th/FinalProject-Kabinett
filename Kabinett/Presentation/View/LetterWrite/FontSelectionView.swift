//
//  FontSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/17/24.
//

import SwiftUI

struct FontSelectionView: View {
    @Binding var letterContent: LetterWriteModel
    @EnvironmentObject var viewModel: FontSelectionViewModel
    
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
                                        prompt: Text("텍스트를 입력해보세요. Write Something...").foregroundColor(Color.black)
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


// MARK: - OpenSourceLicenseModalView
struct OpenSourceLicenseModalView: View {
    var body: some View {
        ZStack {
            Color(.primary100).ignoresSafeArea()

            VStack {
                Text("내장되어 있는 모든 폰트는 SIL Open Font License version 1.1에 따라 사용하고 있습니다. 각 폰트의 저작권은 해당 디자이너에게 있습니다.")
                    .font(.system(size: 11.5))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding([.leading, .trailing], 30)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Text("""
             네이버 나눔 명조 - 네이버
             구름 산스 코드 - 구름
             Pecita -  Philippe Cochy
             Source Han Serif 본명조 - Adobe
             Baskerville - Thomas Huot-Marchand
            """)
                .font(.system(size: 11.5))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding([.leading, .trailing], 30)
                .padding([.top, .bottom], 15)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.leading, .trailing], 40)
            }
        }
    }
}
