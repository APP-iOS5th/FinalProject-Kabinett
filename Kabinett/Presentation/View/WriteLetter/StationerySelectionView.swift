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
    @StateObject var viewModel : StationerySelectionViewModel
    @ObservedObject var customViewModel: CustomTabViewModel
    @ObservedObject var imageViewModel: ImagePickerViewModel
    
    init(
        letterContent: Binding<LetterWriteModel>,
        customViewModel: CustomTabViewModel,
        imageViewModel: ImagePickerViewModel
    ) {
        @Injected(WriteLetterUseCaseKey.self) var writeLetterUseCase: WriteLetterUseCase
        _viewModel = StateObject(wrappedValue: StationerySelectionViewModel(useCase: writeLetterUseCase))
        self._letterContent = letterContent
        self.customViewModel = customViewModel
        self.imageViewModel = imageViewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                List {
                    ForEach(0..<viewModel.numberOfRows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<2, id: \.self) { columnIndex in
                                let index = viewModel.index(row: rowIndex, column: columnIndex)
                                StationeryCell(
                                    index: index,
                                    rowIndex: rowIndex,
                                    columnIndex: columnIndex,
                                    letterContent: $letterContent,
                                    stationerySelectionViewModel: viewModel
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
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
            }
        }
        .sheet(isPresented: $viewModel.showModal) {
            UserSelectionView(letterContent: $letterContent)
                .presentationDetents([.height(300), .large])
        }
        .onAppear {
            viewModel.showModal = true
            
            Task {
                await viewModel.loadStationeries()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("편지지 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ContentWriteView(
                    letterContent: $letterContent,
                    imageViewModel: imageViewModel,
                    customTabViewModel: customViewModel
                )) {
                    Text("다음")
                        .fontWeight(.medium)
                        .font(.system(size: 19))
                        .foregroundStyle(.contentPrimary)
                }
            }
        }
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
