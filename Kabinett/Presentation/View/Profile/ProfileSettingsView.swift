//
//  ProfileSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import PhotosUI

struct ProfileSettingsView: View {
    @ObservedObject var viewModel: ProfileSettingsViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack{
                    Circle()
                        .foregroundColor(.primary300)
                        .frame(width: 110, height: 110)
                    if let image = viewModel.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                }
                .onTapGesture {
                    viewModel.selectProfileImage()
                }
                .padding(.bottom, 10)
                
                ZStack {
                    TextField(viewModel.displayName, text: $viewModel.newUserName)
                        .textFieldStyle(OvalTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .keyboardType(.alphabet)
                        .submitLabel(.done)
                        .frame(alignment: .center)
                        .multilineTextAlignment(.center)
                }
                .font(Font.system(size: 25, design: .default))
                .padding(.bottom, 10)
                
                Text(viewModel.kabinettNumber)
                    .fontWeight(.light)
                    .font(.system(size: 16))
                    .monospaced()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationTitle("프로필 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.completeProfileUpdate()
                    }) {
                        Text("완료")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .foregroundColor(.contentPrimary)
                            .padding(.trailing, 8)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.shouldNavigateToProfile) {
                ProfileView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $viewModel.isShowingImagePicker) {
            ImagePicker(image: $viewModel.selectedImage, isShowingCropper: $viewModel.isShowingCropper)
        }
        .sheet(isPresented: $viewModel.isShowingCropper) {
            ImageCropper(image: $viewModel.selectedImage, isShowingCropper: $viewModel.isShowingCropper, viewModel: viewModel) { croppedImage in
                viewModel.updateProfileImage(with: croppedImage)
            }
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                Capsule()
                    .stroke(Color.primary300, lineWidth: 1)
                    .background(Capsule().fill(Color.white))
            )
            .frame(width: 270, height: 54)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isShowingCropper: Bool
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                        self.parent.isShowingCropper = true
                    }
                }
            }
        }
    }
}

struct ImageCropper: View {
    @Binding var image: UIImage?
    @Binding var isShowingCropper: Bool
    @ObservedObject var viewModel: ProfileSettingsViewModel
    @State private var zoomScale: CGFloat = 1.0
    @State private var dragOffset = CGSize.zero
    var onComplete: (UIImage?) -> Void = { _ in }
    
    var body: some View {
        GeometryReader { geometry in
            if let uiImage = image {
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(zoomScale)
                        .offset(x: dragOffset.width, y: dragOffset.height)
                        .gesture(MagnificationGesture()
                            .onChanged { value in
                                zoomScale = value
                            }
                        )
                        .gesture(DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                        )
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: 110, height: 110)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .clipped()
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                HStack {
                    Spacer()
                    Button("완료") {
                        let croppedImage = viewModel.cropImage(uiImage, in: geometry.size, zoomScale: zoomScale, dragOffset: dragOffset, cropSize: CGSize(width: 110, height: 110))
                        onComplete(croppedImage)
                        isShowingCropper = false
                    }
                    .foregroundColor(.contentPrimary)
                    .padding(.top, 20)
                    .padding(.trailing, 8)
                }
            }
        }
    }
}


#Preview {
    ProfileSettingsView(viewModel: ProfileSettingsViewModel())
}
