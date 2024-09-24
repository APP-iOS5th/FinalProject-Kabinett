//
//  LetterWritePreviewView.swift
//  Kabinett
//
//  Created by Song Kim on 8/29/24.
//

import SwiftUI
import Kingfisher
import UIKit

struct PreviewLetterView: View {
    @Binding var letterContent: LetterWriteModel
    @EnvironmentObject var viewModel: PreviewLetterViewModel
    
    @EnvironmentObject var userSelectionViewModel: UserSelectionViewModel
    @EnvironmentObject var stationerySelectionViewModel: StationerySelectionViewModel
    @EnvironmentObject var fontSelectionViewModel: FontSelectionViewModel
    @EnvironmentObject var contentWriteViewModel: ContentWriteViewModel
    @EnvironmentObject var envelopStampSelectionViewModel: EnvelopeStampSelectionViewModel
    @EnvironmentObject var customTabViewModel: CustomTabViewModel
    @EnvironmentObject var imagePickerViewModel: ImagePickerViewModel
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            VStack {
                NavigationBarView(titleName: "", isColor: true) {
                    NavigationLink(destination: EmptyView()) {}
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.3)
                
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        KFImage(URL(string: letterContent.envelopeImageUrlString))
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                        
                        VStack {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("보내는 사람")
                                        .font(.system(size: 7))
                                    Text(letterContent.fromUserName)
                                        .font(fontSelectionViewModel.selectedFont(font: letterContent.fontString ?? "", size: 14))
                                }
                                
                                Spacer()
                                
                                KFImage(URL(string: letterContent.stampImageUrlString))
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .resizable()
                                    .aspectRatio(9/9.7, contentMode: .fit)
                                    .frame(width: geo.size.width * 0.12)
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .top) {
                                VStack {
                                    Text(letterContent.postScript ?? "")
                                        .font(fontSelectionViewModel.selectedFont(font: letterContent.fontString ?? "", size: 10))
                                        .frame(width: geo.size.width * 0.43, alignment: .leading)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("받는 사람")
                                        .font(.system(size: 7))
                                    Text(letterContent.toUserName)
                                        .font(fontSelectionViewModel.selectedFont(font: letterContent.fontString ?? "", size: 14))
                                }
                                .padding(.top, -1)
                                .padding(.leading, geo.size.width * 0.1)
                                
                                Spacer()
                            }
                            .padding(.top, -1)
                        }
                        .padding(geo.size.height * 0.16)
                    }
                }
                .aspectRatio(9/4, contentMode: .fit)
                .padding(.bottom,30)
                
                VStack {
                    Text("편지가 완성되었어요.")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Text("\(letterContent.toUserName == letterContent.fromUserName ? "나" : letterContent.toUserName)")
                            .font(.system(size: 22, weight: .bold))
                            .padding(.trailing, -3)
                        Text("에게 편지를 보낼까요?")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding(.top, -5)
                }
                
                Spacer()
                
                Button {
                    viewModel.saveLetter(font: letterContent.fontString ?? "",
                                         postScript: letterContent.postScript,
                                         envelope: letterContent.envelopeImageUrlString,
                                         stamp: letterContent.stampImageUrlString,
                                         fromUserId: letterContent.fromUserId,
                                         fromUserName: letterContent.fromUserName,
                                         fromUserKabinettNumber: letterContent.fromUserKabinettNumber,
                                         toUserId: letterContent.toUserId,
                                         toUserName: letterContent.toUserName,
                                         toUserKabinettNumber: letterContent.toUserKabinettNumber,
                                         content: letterContent.content,
                                         photoContents: letterContent.photoContents,
                                         date: letterContent.date,
                                         stationery: letterContent.stationeryImageUrlString ?? "",
                                         isRead: false)
                    
                    letterContent.reset()
                    userSelectionViewModel.reset()
                    stationerySelectionViewModel.reset()
                    fontSelectionViewModel.reset()
                    contentWriteViewModel.reset()
                    envelopStampSelectionViewModel.reset()
                    imagePickerViewModel.resetState()
                    customTabViewModel.hideOptions()
                } label: {
                    Text("편지 보내기")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 56)
                }
                .background(Color("Primary900"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        }
        .slideToDismiss()
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}
