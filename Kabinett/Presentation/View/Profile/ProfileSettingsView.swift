//
//  ProfileSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import PhotosUI

struct ProfileSettingsView: View {
    @State private var userName = "Yule"
    @State private var newUserName = ""
    @State private var profileImage: UIImage?
    @State private var isShowingImagePicker = false
    
    let kabinettNumber = "000-000"
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack{
                    Circle()
                        .foregroundColor(.primary300)
                        .frame(width: 110)
                    if let image = profileImage {
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
                    isShowingImagePicker = true
                }
                .padding(.bottom, 10)
                
                ZStack {
                    TextField("\(userName)", text: $newUserName)
                        .textFieldStyle(OvalTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .keyboardType(.alphabet)
                        .submitLabel(.done)
                        .frame(alignment: .center)
                        .multilineTextAlignment(.center)
                }
                .font(Font.system(size: 25, design: .default))
                .padding(.bottom, 10)
                
                Text("\(kabinettNumber)")
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
                        
                    }) {
                        Text("완료")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .foregroundColor(.contentPrimary)
                            .padding(.trailing, 8)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $profileImage)
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
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
}
