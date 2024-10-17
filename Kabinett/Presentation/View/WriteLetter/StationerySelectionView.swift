//
//  StationerySelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import SwiftUI
import Kingfisher

struct StationerySelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var letterContent: LetterWriteModel
    @EnvironmentObject var stationerySelectionViewModel: StationerySelectionViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                VStack {
                    NavigationBarView(titleName: "편지지 고르기", isColor: true) {
                        NavigationLink(destination: FontSelectionView(letterContent: $letterContent)) {
                            Text("다음")
                                .fontWeight(.medium)
                                .font(.system(size: 19))
                                .foregroundStyle(.contentPrimary)
                        }
                    } backAction: {
                        dismiss()
                    }
                    
                    List {
                        ForEach(0..<stationerySelectionViewModel.numberOfRows, id: \.self) { rowIndex in
                            HStack {
                                ForEach(0..<2, id: \.self) { columnIndex in
                                    let index = stationerySelectionViewModel.index(row: rowIndex, column: columnIndex)
                                    StationeryCell(
                                        index: index,
                                        rowIndex: rowIndex,
                                        columnIndex: columnIndex,
                                        letterContent: $letterContent,
                                        stationerySelectionViewModel: stationerySelectionViewModel
                                    )
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
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
            }
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $stationerySelectionViewModel.showModal) {
                UserSelectionView(letterContent: $letterContent)
                    .presentationDetents([.height(300), .large])
            }
            .onAppear {
                stationerySelectionViewModel.showModal = true
                
                Task {
                    await stationerySelectionViewModel.loadStationeries()
                }
            }
        }
        .slideToDismiss()
    }
}


// MARK: - StationeryCell
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
