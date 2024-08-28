//
//  EnvelopeSelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/27/24.
//

import SwiftUI
import Kingfisher

struct EnvelopeStampSelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @StateObject private var viewModel = EnvelopeStampSelectionViewModal()
    
    @State private var text: String = ""
    @State private var envelopeImageUrl: String
    @State private var stampImageUrl: String
    
    init(letterContent: Binding<LetterWriteViewModel>) {
        _letterContent = letterContent
        _envelopeImageUrl = State(initialValue: letterContent.wrappedValue.envelopeImageUrlString)
        _stampImageUrl = State(initialValue: letterContent.wrappedValue.stampImageUrlString)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    NavigationBarView(destination: WriteLetterView(letterContent: $letterContent), titleName: "봉투와 우표 고르기")
                        .padding(.bottom, 25)
                    
                    VStack {
                        ZStack(alignment: .topLeading) {
                            KFImage(URL(string: envelopeImageUrl))
                                .resizable()
                                .shadow(radius: 5, x: 5, y: 5)
                                .frame(width: .infinity, height: .infinity)
                                .onAppear {
                                    envelopeImageUrl = viewModel.dummyEnvelopes[0]
                                    letterContent.envelopeImageUrlString = envelopeImageUrl
                                }
                            
                            VStack {
                                HStack(alignment: .top) {
                                    VStack {
                                        Text("보내는 사람")
                                            .font(.system(size: 7))
                                            .padding(.bottom, 1)
                                        Text(letterContent.fromUserName)
                                            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 14))
                                    }
                                    .padding(.leading, 25)
                                    
                                    Spacer()
                                    
                                    KFImage(URL(string: stampImageUrl))
                                        .resizable()
                                        .aspectRatio(9/9.7, contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.1, height: .infinity)
                                        .padding(.trailing, 25)
                                        .onAppear {
                                            stampImageUrl = viewModel.dummyStamps[0]
                                            letterContent.stampImageUrlString = stampImageUrl
                                        }
                                }
                                .padding(.top, 25)
                                
                                Spacer()
                                
                                HStack(alignment: .top) {
                                    VStack {
                                        Text(text)
                                            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 10))
                                    }
                                    .padding(.leading, 25)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("받는 사람")
                                            .font(.system(size: 7))
                                            .padding(.bottom, 1)
                                        Text(letterContent.toUserName)
                                            .font(.custom(letterContent.fontString ?? "SFDisplay", size: 14))
                                    }
                                    .padding(.trailing, 100)
                                }
                                .padding(.bottom, 30)
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
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard)
    }
}

struct EnvelopeCell: View {
    @Binding var letterContent: LetterWriteViewModel
    @Binding var envelopeImageUrl: String
    @StateObject private var viewModel = EnvelopeStampSelectionViewModal()
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(0..<viewModel.envelopeNumberOfRows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<2, id: \.self) { columnIndex in
                                let index = viewModel.envelopeIndex(row: rowIndex, column: columnIndex)
                                
                                ZStack(alignment: .topTrailing) {
                                    KFImage(URL(string: viewModel.dummyEnvelopes[index]))
                                        .placeholder {
                                            Image(systemName: "arrow.down.circle.dotted")
                                        }
                                        .resizable()
                                        .aspectRatio(9/4, contentMode: .fit)
                                        .padding(10)
                                        .shadow(radius: 5, x: 5, y: 5)
                                        .onTapGesture {
                                            viewModel.envelopeSelectStationery(coordinates: (rowIndex, columnIndex))
                                            envelopeImageUrl = viewModel.dummyEnvelopes[index]
                                            letterContent.envelopeImageUrlString = viewModel.dummyEnvelopes[index]
                                        }
                                    
                                    if viewModel.isEnvelopeSelected(coordinates: (rowIndex, columnIndex)) {
                                        Image("checked")
                                            .resizable()
                                            .frame(width: 27, height: 27)
                                            .padding([.top, .trailing], 20)
                                            .onAppear {
                                                letterContent.envelopeImageUrlString = viewModel.dummyEnvelopes[viewModel.envelopeIndex(row: rowIndex, column: columnIndex)]
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

struct StampCell: View {
    @Binding var letterContent: LetterWriteViewModel
    @Binding var stampImageUrl: String
    @StateObject private var viewModel = EnvelopeStampSelectionViewModal()
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(0..<viewModel.stampNumberOfRows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<3, id: \.self) { columnIndex in
                                let index = viewModel.stampIndex(row: rowIndex, column: columnIndex)
                                
                                ZStack(alignment: .topTrailing) {
                                    KFImage(URL(string: viewModel.dummyStamps[index]))
                                        .placeholder {
                                            Image(systemName: "arrow.down.circle.dotted")
                                        }
                                        .resizable()
                                        .aspectRatio(9/9.7, contentMode: .fit)
                                        .padding(10)
                                        .shadow(radius: 5, x: 5, y: 5)
                                        .onTapGesture {
                                            viewModel.stampSelectStationery(coordinates: (rowIndex, columnIndex))
                                            stampImageUrl = viewModel.dummyStamps[index]
                                            letterContent.stampImageUrlString = viewModel.dummyStamps[index]
                                        }
                                    
                                    if viewModel.isStampSelected(coordinates: (rowIndex, columnIndex)) {
                                        Image("checked")
                                            .resizable()
                                            .frame(width: 27, height: 27)
                                            .padding([.top, .trailing], 20)
                                            .onAppear {
                                                letterContent.stampImageUrlString = viewModel.dummyStamps[viewModel.stampIndex(row: rowIndex, column: columnIndex)]
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
