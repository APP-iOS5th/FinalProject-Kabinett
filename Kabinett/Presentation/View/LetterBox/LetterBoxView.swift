//
//  LetterBoxView.swift
//  Kabinett
//
//  Created by uunwon on 8/13/24.
//

import SwiftUI

struct LetterBoxView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @StateObject var letterBoxViewModel: LetterBoxViewModel
    
    @State private var showToast: Bool = false
    
    @State private var searchText: String = ""
    @State private var showSearchBarView = false
    
    let columns = [
        GridItem(.flexible(minimum: 220), spacing: -70),
        GridItem(.flexible(minimum: 220))
    ]
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.background
                    
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(LetterBoxType.allCases) { type in
                            NavigationLink(destination: LetterBoxDetailView(letterBoxType: "\(type)", showSearchBarView: $showSearchBarView, searchText: $searchText)) {
                                LetterBoxCell(type: "\(type)", typeName: type.rawValue, letters: letterBoxViewModel.getSomeLetters(for: type.toLetterType()))
                            }
                        }
                    }
                    
                    VStack {
                        if showToast {
                            Spacer()
                            ToastView(message: "편지가 도착했습니다.", horizontalPadding: 50)
                                .transition(.move(edge: .bottom))
                                .zIndex(1)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showToast = false
                                        }
                                    }
                                }
                        }
                    }
                }
                .ignoresSafeArea()
                .onAppear() {
                    withAnimation {
                        if isFirstLaunch {
                            showToast = true
                            isFirstLaunch = false
                        }
                    }
                }
            }
            .tint(.black)
            .buttonStyle(PlainButtonStyle())
            
            if showSearchBarView {
                VStack {
                    ZStack {
                        Color.clear
                            .background(Material.ultraThinMaterial)
                            .blur(radius: 1.5)

                        SearchBarView(searchText: $searchText, showSearchBarView: $showSearchBarView)
                            .padding(.top, 50)
                            .edgesIgnoringSafeArea(.top)
                            .zIndex(1)
                    }
                    .frame(maxHeight: .zero)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LetterBoxView(letterBoxViewModel: LetterBoxViewModel())
}
