//
//  CustomTabView.swift
//  Kabinett
//
//  Created by Song Kim on 8/28/24.
//

import SwiftUI

struct SelectionTabView: View {
    @State private var selectedTab: Int = 0
    @Binding var letterContent: LetterWriteViewModel
    @Binding var envelopeImageUrl: String
    @Binding var stampImageUrl: String
    
    let tabs: [String] = [
        "봉투",
        "우표"
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    CustomTabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        .scrollDisabled(true)
                    
                    TabView(selection: $selectedTab) {
                        EnvelopeCell(letterContent: $letterContent, envelopeImageUrl: $envelopeImageUrl)
                            .tag(0)
                        StampCell(letterContent: $letterContent, stampImageUrl: $stampImageUrl)
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .padding(.top, 10)
                    .background(Color(.background))
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct CustomTabs: View {
    var tabs: [String]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    Text(tabs[row])
                                        .font(Font.system(size: 15))
                                        .foregroundColor(Color.black)
                                        .padding(EdgeInsets(top: 10, leading: 3, bottom: 5, trailing: 15))
                                        .frame(width: geoWidth / CGFloat(tabs.count))
                                    
                                    Rectangle()
                                        .fill(selectedTab == row ? Color.black : Color.clear)
                                        .frame(width: 70, height: 3)
                                        .padding(.leading, -12.5)
                                }
                                .fixedSize()
                                .background(Color(.background))
                            })
                            .accentColor(Color.black)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) {
                        withAnimation {
                            proxy.scrollTo(selectedTab)
                        }
                    }
                }
            }
        }
        .frame(height: 33)
    }
}
