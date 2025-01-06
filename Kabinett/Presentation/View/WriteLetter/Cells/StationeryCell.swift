//
//  StationeryCell.swift
//  Kabinett
//
//  Created by Song Kim on 1/6/25.
//

import Foundation

struct StationeryCell: View {
    let index: Int
    let rowIndex: Int
    let columnIndex: Int
    @Binding var letterContent: LetterWriteModel
    @ObservedObject var stationerySelectionViewModel: StationerySelectionViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if stationerySelectionViewModel.stationerys.indices.contains(index) {
                KFImage(URL(string: stationerySelectionViewModel.stationerys[index]))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(9/13, contentMode: .fit)
                    .padding(10)
                    .shadow(color: Color(.primary300), radius: 5, x: 3, y: 3)
                    .onTapGesture {
                        stationerySelectionViewModel.selectStationery(coordinates: (rowIndex, columnIndex))
                        letterContent.stationeryImageUrlString = stationerySelectionViewModel.stationerys[index]
                    }
            } else {
                EmptyView()
            }
            
            if stationerySelectionViewModel.isSelected(coordinates: (rowIndex, columnIndex)) {
                Image("checked")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding([.top, .trailing], 20)
                    .onAppear {
                        letterContent.stationeryImageUrlString = stationerySelectionViewModel.stationerys[index]
                    }
            }
        }
    }
}
