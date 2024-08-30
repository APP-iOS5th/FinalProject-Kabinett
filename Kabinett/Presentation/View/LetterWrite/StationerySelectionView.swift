//
//  StationerySelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import SwiftUI
import Kingfisher

struct StationerySelectionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @EnvironmentObject var stationerySelectionViewModel: StationerySelectionViewModel
    @EnvironmentObject var envelopeStampSelectionViewModel: EnvelopeStampSelectionViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    Color("Background").ignoresSafeArea()
                    
                    VStack {
                        NavigationBarView(destination: FontSelectionView(letterContent: $letterContent), titleName: "편지지 고르기", isNavigation: true)
                        
                        List {
                            ForEach(0..<stationerySelectionViewModel.numberOfRows, id: \.self) { rowIndex in
                                HStack {
                                    ForEach(0..<2, id: \.self) { columnIndex in
                                        let index = stationerySelectionViewModel.index(row: rowIndex, column: columnIndex)
                                        
                                        ZStack(alignment: .topTrailing) {
                                            KFImage(URL(string: stationerySelectionViewModel.stationerys[index]))
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .resizable()
                                                .aspectRatio(9/13, contentMode: .fit)
                                                .padding(10)
                                                .shadow(radius: 5, x: 5, y: 5)
                                                .onTapGesture {
                                                    stationerySelectionViewModel.selectStationery(coordinates: (rowIndex, columnIndex))
                                                    letterContent.stationeryImageUrlString = stationerySelectionViewModel.stationerys[index]
                                                }
                                            
                                            if stationerySelectionViewModel.isSelected(coordinates: (rowIndex, columnIndex)) {
                                                Image("checked")
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                                    .padding([.top, .trailing], 20)
                                                    .onAppear {
                                                        letterContent.stationeryImageUrlString = stationerySelectionViewModel.stationerys[stationerySelectionViewModel.index(row: rowIndex, column: columnIndex)]
                                                    }
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
            .sheet(isPresented: $stationerySelectionViewModel.showModal) {
                UserSelectionModalView(letterContent: $letterContent)
                    .presentationDetents([.height(300), .large])
            }
            .onAppear {
                stationerySelectionViewModel.showModal = true
                
                Task {
                    await stationerySelectionViewModel.loadStationeries()
                    await envelopeStampSelectionViewModel.loadStamps()
                    await envelopeStampSelectionViewModel.loadEnvelopes()
                }
            }
        }
    }
}
