////
////  OptionOverlay.swift
////  Kabinett
////
////  Created by 김정우 on 8/13/24.
////
//
//import SwiftUI
//
//struct OptionOverlay: View {
//    @AppStorage("isFirstWrite") private var isFirstWrite: Bool = true
//    @ObservedObject var customTabViewModel: CustomTabViewModel
//    @State private var letterContent = LetterWriteModel()
//    @State private var isWritingLetter = false
//    @ObservedObject var imageViewModel: ImagePickerViewModel
//    
//    var body: some View {
//        VStack {
//            
//        }
//    }
//}
//
//// MARK: - 배경색 제거를 위한 코드
//struct ClearBackground: UIViewRepresentable {
//    public func makeUIView(context: Context) -> UIView {
//        let view = ClearBackgroundView()
//        DispatchQueue.main.async {
//            view.superview?.superview?.backgroundColor = .clear
//        }
//        return view
//    }
//    public func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//class ClearBackgroundView: UIView {
//    open override func layoutSubviews() {
//        guard let parentView = superview?.superview else {
//            return
//        }
//        parentView.backgroundColor = .clear
//    }
//}
