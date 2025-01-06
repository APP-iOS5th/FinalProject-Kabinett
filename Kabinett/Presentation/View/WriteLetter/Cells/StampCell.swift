//
//  StampCell.swift
//  Kabinett
//
//  Created by Song Kim on 1/6/25.
//

import Foundation

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
