//
//  MiniTabBar.swift
//  Kabinett
//
//  Created by Song Kim on 1/6/25.
//

import SwiftUI
import PhotosUI

struct MiniTabBarView: View {
    @ObservedObject var viewModel: ContentWriteViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    
    var body: some View {
        if viewModel.currentIndex < viewModel.texts.count {
            HStack(alignment: .center) {
                Button {
                    viewModel.toggleFontView()
                } label: {
                    Text("F")
                        .bold()
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: 30)
                        .background(viewModel.isFontEdit ? Color.clear : Color(.primary300))
                        .clipShape(Capsule())
                }
                .disabled(viewModel.isFontEdit ? false : true)
                .onChange(of: viewModel.texts) {
                    if viewModel.texts.contains(where: { !$0.isEmpty }) {
                        viewModel.isFontEdit = false
                    } else {
                        viewModel.isFontEdit = true
                    }
                }
                
                Button {
                    // TODO: 편지지컬러피커
                } label: {
                    Image(systemName: "paintbrush")
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: 30)
                        .background(viewModel.isFontEdit ? Color.clear : Color(.primary300))
                        .clipShape(Capsule())
                }
                
                Button {
                    if viewModel.texts.count > 1 {
                        viewModel.isDeleteAlertPresented = true
                    }
                } label: {
                    Image("PageMinus")
                        .font(.system(size: 15))
                        .frame(width: UIScreen.main.bounds.width * 0.1, height: 30)
                }
                .alert(isPresented: $viewModel.isDeleteAlertPresented) {
                    Alert(
                        title: Text("Delete Page"),
                        message: Text("현재 페이지를 지우시겠어요?"),
                        primaryButton: .destructive(Text("삭제")) {
                            viewModel.deleteLetter(idx: viewModel.currentIndex)
                        },
                        secondaryButton: .cancel(Text("취소")) {
                            viewModel.isDeleteAlertPresented = false
                        }
                    )
                }
                Button {
                    viewModel.createNewLetter(idx: viewModel.currentIndex)
                } label: {
                    Image(systemName: "doc.badge.plus")
                        .font(.system(size: 15))
                        .frame(width: UIScreen.main.bounds.width * 0.1)
                }
                PhotosPicker(
                    selection: $viewModel.selectedItems,
                    maxSelectionCount: 10,
                    matching: .images) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 15))
                            .frame(width: UIScreen.main.bounds.width * 0.1, height: 30)
                            .background(viewModel.selectedItems.isEmpty ? Color.clear : Color.white)
                            .foregroundStyle(viewModel.selectedItems.isEmpty ? Color("ToolBarIcon") : Color(.primary900))
                            .clipShape(Capsule())
                            .shadow(color: viewModel.selectedItems.isEmpty ? Color.clear : Color(.primary300), radius: 7, x: 3, y: 3)
                    }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6, maxHeight: 40)
            .foregroundStyle(Color("ToolBarIcon"))
            .background(Color(.primary100))
            .clipShape(Capsule())
            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
            .padding(.top, -10)
        }
    }
}
