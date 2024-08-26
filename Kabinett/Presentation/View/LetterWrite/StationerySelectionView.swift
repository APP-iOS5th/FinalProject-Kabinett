//
//  StationerySelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import SwiftUI

struct StationerySelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = StationerySelectionViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Color("Background").ignoresSafeArea()
                
                VStack {
                    NavigationBarView(destination: FontSelectionView(letterContent: $letterContent), titleName: "편지지 고르기")
                    
                    List {
                        ForEach(0..<viewModel.numberOfRows, id: \.self) { rowIndex in
                            HStack {
                                ForEach(0..<2, id: \.self) { columnIndex in
                                    let index = viewModel.index(row: rowIndex, column: columnIndex)
                                    
                                    ZStack(alignment: .topTrailing) {
                                        AsyncImage(url: URL(string: viewModel.dummyStationerys[index])) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .padding(10)
                                                .shadow(radius: 5, x: 5, y: 5)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .onTapGesture {
                                            viewModel.selectStationery(coordinates: (rowIndex, columnIndex))
                                            letterContent.stationeryImageUrlString = viewModel.dummyStationerys[index]
                                        }
                                        
                                        if viewModel.isSelected(coordinates: (rowIndex, columnIndex)) {
                                            Image("checked")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .padding([.top, .trailing], 20)
                                        }
                                    }
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                    .padding([.leading, .trailing], -10)
                }
                .padding(.horizontal, geometry.size.width * 0.06)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.showModal) {
            UserSelectionModalView(letterContent: $letterContent)
                .presentationDetents([.height(300), .large])
        }
        .onAppear {
            viewModel.showModal = true
        }
    }
}
