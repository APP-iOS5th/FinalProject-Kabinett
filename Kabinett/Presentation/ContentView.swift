//
//  ContentView.swift
//  Kabinett
//
//  Created by jinwoong Kim on 8/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var componentsUseCase = MockComponentsUseCase()
    @StateObject private var componentsLoadStuffUseCase = MockComponentsLoadStuffUseCase()
    
    var body: some View {
        CustomTabView(componentsUseCase: componentsUseCase, componentsLoadStuffUseCase: componentsLoadStuffUseCase)
        {
            LetterBoxView()
                .tag(0)
            // + OptionOverlay Button
            Color.clear
            
            ProfileViewSample()
                .tag(2)
        }
    }
}
#Preview {
    ContentView()
}
