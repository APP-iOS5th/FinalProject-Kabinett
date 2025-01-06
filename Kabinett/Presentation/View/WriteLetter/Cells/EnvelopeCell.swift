//
//  EnvelopeCell.swift
//  Kabinett
//
//  Created by Song Kim on 1/6/25.
//

import Foundation

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
