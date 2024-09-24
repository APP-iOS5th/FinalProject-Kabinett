//
//  EnvelopeSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import SwiftUI
import Kingfisher

struct EnvelopeStampSelectionView: View {
    @Binding var letterContent: LetterWriteModel
    @EnvironmentObject var viewModel: EnvelopeStampSelectionViewModel
    @EnvironmentObject var imagePickerViewModel: ImagePickerViewModel
    @EnvironmentObject var fontViewModel: FontSelectionViewModel
    @State private var text: String = ""
    @State private var envelopeImageUrl: String
    @State private var stampImageUrl: String
    @State private var postScriptText: String = ""
    
    init(letterContent: Binding<LetterWriteModel>) {
        self._letterContent = letterContent
        _envelopeImageUrl = State(initialValue: letterContent.wrappedValue.envelopeImageUrlString)
        _stampImageUrl = State(initialValue: letterContent.wrappedValue.stampImageUrlString)
        _postScriptText = State(initialValue: letterContent.wrappedValue.postScript ?? "")
    }
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                if letterContent.dataSource == .fromImagePicker {
                    NavigationBarView(titleName: "봉투와 우표 고르기", isColor: true) {
                        NavigationLink(destination: LetterCompletionView(letterContent: $letterContent)) {
                            Text("다음")
                                .fontWeight(.medium)
                                .font(.system(size: 19))
                                .foregroundStyle(.contentPrimary)
                        }
                    }
                    .padding(.bottom, 25)
                } else {
                    NavigationBarView(titleName: "봉투와 우표 고르기", isColor: true) {
                        NavigationLink(destination: PreviewLetterView(letterContent: $letterContent)) {
                            Text("다음")
                                .fontWeight(.medium)
                                .font(.system(size: 19))
                                .foregroundStyle(.contentPrimary)
                        }
                    }
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    .padding(.bottom, 25)
                }
                
                VStack {
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            if let firstEnvelope = viewModel.envelopes.first {
                                KFImage(URL(string: envelopeImageUrl))
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .resizable()
                                    .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                                    .onAppear {
                                        if letterContent.envelopeImageUrlString.isEmpty {
                                            envelopeImageUrl = firstEnvelope
                                        }
                                        letterContent.envelopeImageUrlString = envelopeImageUrl
                                    }
                            }
                            
                            VStack {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("보내는 사람")
                                            .font(.system(size: 7))
                                        Text(letterContent.fromUserName)
                                            .font(fontViewModel.selectedFont(font: letterContent.fontString ?? "", size: 14))
                                    }
                                    
                                    Spacer()
                                    
                                    if let firstStamp = viewModel.stamps.first {
                                        KFImage(URL(string: stampImageUrl))
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .resizable()
                                            .aspectRatio(9/9.7, contentMode: .fit)
                                            .frame(width: geo.size.width * 0.12)
                                            .onAppear {
                                                if letterContent.stampImageUrlString.isEmpty {
                                                    stampImageUrl = firstStamp
                                                }
                                                letterContent.stampImageUrlString = stampImageUrl
                                            }
                                    }
                                }
                                
                                Spacer()
                                
                                HStack(alignment: .top) {
                                    VStack {
                                        Text(text)
                                            .font(fontViewModel.selectedFont(font: letterContent.fontString ?? "", size: 10))
                                            .frame(width: geo.size.width * 0.43, alignment: .leading)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("받는 사람")
                                            .font(.system(size: 7))
                                        Text(letterContent.toUserName)
                                            .font(fontViewModel.selectedFont(font: letterContent.fontString ?? "", size: 14))
                                    }
                                    .padding(.top, -1)
                                    .padding(.leading, geo.size.width * 0.1)
                                    
                                    Spacer()
                                }
                                .padding(.top, -1)
                            }
                            .padding((geo.size.height * 0.16))
                        }
                    }
                    .aspectRatio(9/4, contentMode: .fit)
                    .padding(.bottom, 50)
                    
                    VStack(alignment: .leading) {
                        Text("봉투에 적을 내용")
                            .font(.system(size: 13))
                            .padding(.bottom, 1)
                        TextField("최대 15글자를 적을 수 있어요.", text: $text)
                            .maxLength(text: $text, 15)
                            .padding(.leading, 6)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, minHeight: 35, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onChange(of: text) {
                                letterContent.postScript = text
                            }
                    }
                    .padding(.bottom, 30)
                }
                SelectionTabView(letterContent: $letterContent, envelopeImageUrl: $envelopeImageUrl, stampImageUrl: $stampImageUrl)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        }
        .slideToDismiss()
        .task {
            postScriptText = letterContent.postScript ?? ""
            if letterContent.dataSource == .fromImagePicker {
                await imagePickerViewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeImageUrl = imagePickerViewModel.envelopeURL ?? ""
                stampImageUrl = imagePickerViewModel.stampURL ?? ""
            } else {
                await imagePickerViewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeImageUrl = letterContent.envelopeImageUrlString
                stampImageUrl = letterContent.stampImageUrlString
            }
        }
        .onChange(of: envelopeImageUrl) { _, newValue in
            imagePickerViewModel.updateEnvelopeAndStamp(envelope: newValue, stamp: stampImageUrl)
            letterContent.envelopeImageUrlString = newValue
        }
        .onChange(of: stampImageUrl) { _, newValue in
            imagePickerViewModel.updateEnvelopeAndStamp(envelope: envelopeImageUrl, stamp: newValue)
            letterContent.stampImageUrlString = newValue
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}


// MARK: - EnvelopeCell
struct EnvelopeCell: View {
    @Binding var letterContent: LetterWriteModel
    @Binding var envelopeImageUrl: String
    @EnvironmentObject var viewModel: EnvelopeStampSelectionViewModel
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(0..<viewModel.envelopeNumberOfRows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<2, id: \.self) { columnIndex in
                                let index = viewModel.envelopeIndex(row: rowIndex, column: columnIndex)
                                
                                if index < viewModel.envelopes.count {
                                    ZStack(alignment: .topTrailing) {
                                        KFImage(URL(string: viewModel.envelopes[index]))
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .resizable()
                                            .aspectRatio(9/4, contentMode: .fit)
                                            .padding(10)
                                            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                                            .onTapGesture {
                                                viewModel.envelopeSelectStationery(coordinates: (rowIndex, columnIndex))
                                                envelopeImageUrl = viewModel.envelopes[index]
                                                letterContent.envelopeImageUrlString = viewModel.envelopes[index]
                                            }
                                        
                                        if viewModel.isEnvelopeSelected(coordinates: (rowIndex, columnIndex)) {
                                            Image("checked")
                                                .resizable()
                                                .frame(width: 27, height: 27)
                                                .padding([.top, .trailing], 20)
                                                .onAppear {
                                                    letterContent.envelopeImageUrlString = viewModel.envelopes[viewModel.envelopeIndex(row: rowIndex, column: columnIndex)]
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 10)
                    }
                }
                .listStyle(.plain)
                .padding(.leading, -10)
                .padding(.trailing, -5)
            }
        }
    }
}


// MARK: - StampCell
struct StampCell: View {
    @Binding var letterContent: LetterWriteModel
    @Binding var stampImageUrl: String
    @EnvironmentObject var viewModel: EnvelopeStampSelectionViewModel
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(0..<viewModel.stampNumberOfRows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<3, id: \.self) { columnIndex in
                                let index = viewModel.stampIndex(row: rowIndex, column: columnIndex)
                                
                                if index < viewModel.stamps.count {
                                    ZStack(alignment: .topTrailing) {
                                        KFImage(URL(string: viewModel.stamps[index]))
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .resizable()
                                            .aspectRatio(9/9.7, contentMode: .fit)
                                            .padding(10)
                                            .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                                            .onTapGesture {
                                                viewModel.stampSelectStationery(coordinates: (rowIndex, columnIndex))
                                                stampImageUrl = viewModel.stamps[index]
                                                letterContent.stampImageUrlString = viewModel.stamps[index]
                                            }
                                        
                                        if viewModel.isStampSelected(coordinates: (rowIndex, columnIndex)) {
                                            Image("checked")
                                                .resizable()
                                                .frame(width: 27, height: 27)
                                                .padding([.top, .trailing], 20)
                                                .onAppear {
                                                    letterContent.stampImageUrlString = viewModel.stamps[viewModel.stampIndex(row: rowIndex, column: columnIndex)]
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 10)
                    }
                }
                .listStyle(.plain)
                .padding(.leading, -10)
                .padding(.trailing, -5)
            }
        }
    }
}
