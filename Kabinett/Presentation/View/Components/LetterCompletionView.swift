//
//  LetterCompletionView.swift
//  Kabinett
//
//  Created by 김정우 on 8/20/24.
//

import SwiftUI


struct LetterCompletionView: View {
    @StateObject private var viewModel: ImagePickerViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(componentsUseCase: ComponentsUseCase, componentsLoadStuffUseCase: ComponentsLoadStuffUseCase) {
        _viewModel = StateObject(wrappedValue: ImagePickerViewModel(componentsUseCase: componentsUseCase, componentsLoadStuffUseCase: componentsLoadStuffUseCase))
    }
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                headerView
                Spacer()
                letterPreviewView
                completionMessageView
                Spacer()
                saveButton
            }
        }
        .onAppear {
            Task {
                await viewModel.loadEnvelopeAndStamp()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
    }
    
    private var letterPreviewView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.white)
                .frame(width: 315, height: 145)
                .shadow(radius: 5)
            
            if let envelopeURL = viewModel.envelopeURL {
                AsyncImage(url: URL(string: envelopeURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 315, height: 145)
            }
            
            GeometryReader { geometry in
                ZStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("보내는 사람")
                            .font(.system(size: 7))
                        Text(viewModel.fromUserName)
                            .font(.system(size: 14))
                    }
                    .position(x: 60, y: 35)
                    
                    Text(viewModel.formattedDate)
                        .font(.system(size: 12))
                        .position(x: geometry.size.width - 80, y: 25)
                    
                    Text(viewModel.postScript ?? "")
                        .font(.system(size: 10))
                        .position(x: 85, y: geometry.size.height - 35)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("받는 사람")
                            .font(.system(size: 7))
                        Text(viewModel.toUserName)
                            .font(.system(size: 14))
                    }
                    .position(x: geometry.size.width - 90, y: geometry.size.height - 30)
                    
                    if let stampURL = viewModel.stampURL {
                        AsyncImage(url: URL(string: stampURL)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 34, height: 38)
                        .position(x: geometry.size.width - 40, y: 35)
                    }
                }
            }
        }
        .frame(width: 315, height: 145)
    }
    
    private var completionMessageView: some View {
        VStack(spacing: 10) {
            Text("편지가 완성되었어요.")
            Text("소중한 편지를 보관할게요.")
        }
        .font(.system(size: 18, weight: .medium))
    }
    
    private var saveButton: some View {
        Button(action: {
            Task {
                await viewModel.saveImportingImage()
            }
        }) {
            Text("편지 보관하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Primary900"))
                .cornerRadius(14)
        }
        .padding(.horizontal)
        .disabled(viewModel.isLoading)
    }
}



#Preview {
    LetterCompletionView(componentsUseCase: MockComponentsUseCase(), componentsLoadStuffUseCase: MockComponentsLoadStuffUseCase())
}

// Preview 더미 데이터
class MockComponentsUseCase: ComponentsUseCase {
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String?, fromUserName: String, fromUserKabinettNumber: Int?, toUserId: String?, toUserName: String, toUserKabinettNumber: Int?, photoContents: [Data], date: Date, isRead: Bool) async -> Result<Bool, any Error> {
        return .success(true)
    }
}

class MockComponentsLoadStuffUseCase: ComponentsLoadStuffUseCase {
    func loadEnvelopes() async -> Result<[String], any Error> {
        return .success(["https://envelopes.jpg"])
    }
    
    func loadStamps() async -> Result<[String], any Error> {
        return .success(["https://stamps.jpg"])
    }
}
