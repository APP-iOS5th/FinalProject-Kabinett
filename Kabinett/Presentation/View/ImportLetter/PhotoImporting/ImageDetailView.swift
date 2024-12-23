//
//  ImageDetailView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import FirebaseAnalytics
import SwiftUI

struct ImageDetailView: View {
    let images: [Data]
    @State private var currentIndex = 0
    @Binding var showDetailView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        if let uiImage = UIImage(data: images[index]) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    Button(action: { currentIndex = max(currentIndex - 1, 0) }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    .opacity(currentIndex > 0 ? 1 : 0)
                    
                    Spacer()
                    
                    Button(action: { currentIndex = min(currentIndex + 1, images.count - 1) }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .opacity(currentIndex < images.count - 1 ? 1 : 0)
                }
                .padding()
            }
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .analyticsScreen(
            name: "\(type(of:self))",
            extraParameters: [
                AnalyticsParameterScreenName: "\(type(of:self))",
                AnalyticsParameterScreenClass: "\(type(of:self))",
            ]
        )
    }
}
