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
    @StateObject var viewModel: EnvelopeStampSelectionViewModel
    @ObservedObject var imageViewModel: ImagePickerViewModel
    @ObservedObject var customTabViewModel: CustomTabViewModel
    @State private var text: String = ""
    @State private var envelopeImageUrl: String
    @State private var stampImageUrl: String
    @State private var postScriptText: String = ""
    
    init(
        letterContent: Binding<LetterWriteModel>,
        customTabViewModel: CustomTabViewModel,
        imageViewModel: ImagePickerViewModel
    ) {
        self._letterContent = letterContent
        self.imageViewModel = imageViewModel
        self.customTabViewModel = customTabViewModel
        
        _envelopeImageUrl = State(initialValue: letterContent.wrappedValue.envelopeImageUrlString)
        _stampImageUrl = State(initialValue: letterContent.wrappedValue.stampImageUrlString)
        _postScriptText = State(initialValue: letterContent.wrappedValue.postScript ?? "")
        
        @Injected(WriteLetterUseCaseKey.self) var writeLetterUseCase: WriteLetterUseCase
        _viewModel = StateObject(wrappedValue: EnvelopeStampSelectionViewModel(useCase: writeLetterUseCase))
    }
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                WriteLetterEnvelopeCell(letter: Letter(fontString: letterContent.fontString, postScript: letterContent.postScript, envelopeImageUrlString: letterContent.envelopeImageUrlString, stampImageUrlString: letterContent.stampImageUrlString, fromUserId: letterContent.fromUserId, fromUserName: letterContent.fromUserName, fromUserKabinettNumber: letterContent.fromUserKabinettNumber, toUserId: letterContent.toUserId, toUserName: letterContent.toUserName, toUserKabinettNumber: letterContent.toUserKabinettNumber, content: letterContent.content, photoContents: [""], date: letterContent.date, stationeryImageUrlString: letterContent.stationeryImageUrlString, isRead: true))
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                    .onChange(of: viewModel.envelopes) {
                        if letterContent.envelopeImageUrlString.isEmpty {
                            envelopeImageUrl = viewModel.envelopes[0]
                        }
                    }
                    .onChange(of: viewModel.stamps) {
                        if letterContent.stampImageUrlString.isEmpty {
                            stampImageUrl = viewModel.stamps[0]
                        }
                    }
                
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
                
                SelectionTabView(envelopeStampSelectionViewModel: viewModel, letterContent: $letterContent, envelopeImageUrl: $envelopeImageUrl, stampImageUrl: $stampImageUrl)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        }
        .task {
            await viewModel.loadStamps()
            await viewModel.loadEnvelopes()
            
            postScriptText = letterContent.postScript ?? ""
            if letterContent.dataSource == .fromImagePicker {
                await imageViewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeImageUrl = imageViewModel.envelopeURL ?? ""
                stampImageUrl = imageViewModel.stampURL ?? ""
            } else {
                await imageViewModel.loadAndUpdateEnvelopeAndStamp()
                envelopeImageUrl = letterContent.envelopeImageUrlString
                stampImageUrl = letterContent.stampImageUrlString
            }
        }
        .onChange(of: envelopeImageUrl) { _, newValue in
            imageViewModel.updateEnvelopeAndStamp(envelope: newValue, stamp: stampImageUrl)
            letterContent.envelopeImageUrlString = newValue
        }
        .onChange(of: stampImageUrl) { _, newValue in
            imageViewModel.updateEnvelopeAndStamp(envelope: envelopeImageUrl, stamp: newValue)
            letterContent.stampImageUrlString = newValue
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("봉투와 우표 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if letterContent.dataSource == .fromImagePicker {
                    NavigationLink(destination: LetterCompletionView(
                        letterContent: $letterContent,
                        viewModel: imageViewModel,
                        customTabViewModel: customTabViewModel,
                        envelopeStampSelectionViewModel: viewModel
                    )) {
                        Text("다음")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundStyle(.contentPrimary)
                    }
                } else {
                    NavigationLink(destination: PreviewLetterView(
                        letterContent: $letterContent,
                        customTabViewModel: customTabViewModel,
                        imagePickerViewModel: imageViewModel
                    )) {
                        Text("다음")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundStyle(.contentPrimary)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}


// MARK: - EnvelopeCell
struct EnvelopeCell: View {
    @Binding var letterContent: LetterWriteModel
    @Binding var envelopeImageUrl: String
    @ObservedObject var viewModel: EnvelopeStampSelectionViewModel
    
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
    @ObservedObject var viewModel: EnvelopeStampSelectionViewModel
    
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
