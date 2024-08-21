//
//  WriteLetterView.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import SwiftUI

struct WriteLetterView: View {
    @Binding var letterContent: LetterWriteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            GeometryReader { geometry in
                
                VStack(alignment: .leading) {
                    NavigationBarView(destination: ModalTestView(), titleName: "")
                    
                    AsyncImage(url: URL(string: letterContent.stationeryImageUrlString ?? "")) { image in
                        image
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(10)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text(letterContent.toUserName)
                    Text(letterContent.fontString ?? "")
                    
                }
                .padding(.horizontal, geometry.size.width * 0.06)
                
            }
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    ModalTestView()
}
