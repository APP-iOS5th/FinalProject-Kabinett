//
//  StationerySelectionView.swift
//  Kabinett
//
//  Created by Song Kim on 8/13/24.
//

import SwiftUI

struct StationerySelectionView: View {
    @State private var showModal = true
    @Binding var letterContent: LetterViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedIndex: (Int, Int) = (0, 0)
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(0..<8) { i in
                        HStack {
                            ForEach(0..<2, id: \.self) { j in
                                ZStack(alignment: .topTrailing) {
                                    Image("paper")
                                        .resizable()
                                        .renderingMode(.original)
                                        .scaledToFill()
                                        .padding(.all, 10)
                                        .shadow(radius: 5, x: 5, y: 5)
                                        .onTapGesture {
                                            selectedIndex = (i, j)
                                        }
                                    
                                    if selectedIndex == (i, j) {
                                        Image(systemName: "checkmark.circle")
                                            .font(.title)
                                            .foregroundColor(Color("Secondary900"))
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
                        .foregroundStyle(Color.black)
                }
                .padding(.leading, 8)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("완료") {
                    FontSelectionView()
                }
                .foregroundStyle(Color.black)
                .padding(.trailing, 8)
            }
        }
        .sheet(isPresented: self.$showModal) {
            UserSelectionView(letterContent: $letterContent)
                .presentationDetents([.medium, .large])
        }
        .background(Color("Background").ignoresSafeArea())
    }
}
