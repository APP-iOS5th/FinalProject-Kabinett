//
//  OptionOverlay.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI

struct OptionOverlay: View {
    @AppStorage("isFirstWrite") private var isFirstWrite: Bool = true
    @ObservedObject var customTabViewModel: CustomTabViewModel
    @State private var letterContent = LetterWriteModel()
    @State private var isWritingLetter = false
    @ObservedObject var imageViewModel: ImagePickerViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            customTabViewModel.hideOptions()
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    if isFirstWrite {
                        OptionGuideView()
                    }
                    
                    HStack(spacing: 2) {
                        Button(action: {
                            customTabViewModel.showImportDialogAndHideOptions()
                            customTabViewModel.hideOptions()
                        }) {
                            Text("편지 보관하기")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 24)
                                .padding()
                                .background(Color.primary100)
                                .foregroundColor(.contentPrimary)
                        }
                        
                        NavigationLink("편지 쓰기") {
                            StationerySelectionView(
                                letterContent: $letterContent,
                                customViewModel: customTabViewModel,
                                imageViewModel: imageViewModel
                            )
                        }
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .padding()
                        .background(Color.primary100)
                        .foregroundColor(.contentPrimary)
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, customTabViewModel.calculateOptionOverlayBottomPadding())
                }
                .background(Color.clear)
            }
            .background(ClearBackground())
            .onDisappear {
                if isFirstWrite {
                    isFirstWrite = false
                }
            }
        }
    }
}


// MARK: - 배경색 제거를 위한 코드
struct ClearBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIView {
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}
