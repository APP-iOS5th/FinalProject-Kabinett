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
            Color("Background").ignoresSafeArea()
            
            VStack {
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
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("ContentPrimary"))
                }
                .padding(.leading, 8)
            }
            ToolbarItem(placement: .principal) {
                Text("편지지 고르기")
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("완료") {
                    FontSelectionView(letterContent: $letterContent)
                }
                .foregroundStyle(Color.black)
                .padding(.trailing, 8)
            }
        }
        .toolbarBackground(Color("Background"), for: .navigationBar)
        .sheet(isPresented: $viewModel.showModal) {
            UserSelectionView(letterContent: $letterContent)
                .presentationDetents([.height(300), .large])
        }
    }
}
