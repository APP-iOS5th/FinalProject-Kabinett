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
    @ObservedObject var dummyData = DummyData()
    
    @State private var showModal = true
    @State private var selectedIndex: (Int, Int) = (0, 0)
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(0..<dummyData.dummyStationerys.count / 2, id: \.self) { i in
                        HStack {
                            ForEach(0..<2, id: \.self) { j in
                                let index = i * 2 + j
                                ZStack(alignment: .topTrailing) {
                                    AsyncImage(url: URL(string: dummyData.dummyStationerys[index])) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .padding(10)
                                            .shadow(radius: 5, x: 5, y: 5)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .onTapGesture {
                                        selectedIndex = (i, j)
                                        letterContent.stationeryImageUrlString = dummyData.dummyStationerys[index]
                                    }
                                    if selectedIndex == (i, j) {
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
        .navigationTitle("편지지 고르기")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("ContentPrimary"))
                }
                .padding(.leading, 8)
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
        .sheet(isPresented: self.$showModal) {
            UserSelectionView(letterContent: $letterContent)
                .presentationDetents([.height(300), .large])
        }
    }
}
