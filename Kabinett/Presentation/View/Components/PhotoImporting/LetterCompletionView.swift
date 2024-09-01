//
//  LetterCompletionView.swift
//  Kabinett
//
//  Created by 김정우 on 8/20/24.
//

import SwiftUI
import Kingfisher

struct LetterCompletionView: View {
    @Binding var letterContent: LetterWriteViewModel
    @EnvironmentObject var viewModel: ImagePickerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    letterPreviewView
                    completionMessageView
                    Spacer()
                    saveButton
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            Task {
                await viewModel.loadEnvelopeAndStamp()
                print("Envelope URL: \(viewModel.envelopeURL ?? "nil")")
                print("Stamp URL: \(viewModel.stampURL ?? "nil")")
            }
        }
    }
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.contentPrimary)
                .imageScale(.large)
        }
    }
    
    private var letterPreviewView: some View {
        ZStack {
            KFImage(URL(string: letterContent.envelopeImageUrlString))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .frame(width: 315, height: 145)
            
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
                        KFImage(URL(string: stampURL))
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .frame(width: 34, height: 38)
                            .position(x: geometry.size.width - 40, y: 35)
                            .id(stampURL)
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
                print("Saving letter")
                await viewModel.saveImportingImage()
            }
        }) {
            Text("편지 보관하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary900)
                .cornerRadius(14)
        }
        .padding(.horizontal)
        .disabled(viewModel.isLoading)
    }
}



#Preview {
    LetterCompletionView(letterContent: .constant(LetterWriteViewModel()))
        .environmentObject(ImagePickerViewModel(
            componentsUseCase: MockComponentsUseCase(),
            componentsLoadStuffUseCase: MockComponentsLoadStuffUseCase()
        ))
}

// Preview 더미 데이터
class MockComponentsUseCase: ObservableObject, ComponentsUseCase {
    func saveLetter(postScript: String?, envelope: String, stamp: String, fromUserId: String?, fromUserName: String, fromUserKabinettNumber: Int?, toUserId: String?, toUserName: String, toUserKabinettNumber: Int?, photoContents: [Data], date: Date, isRead: Bool) async -> Result<Bool, any Error> {
        return .success(true)
    }
}

class MockComponentsLoadStuffUseCase: ObservableObject, ComponentsLoadStuffUseCase {
    func loadEnvelopes() async -> Result<[String], any Error> {
        return .success([
            "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
            "https://postfiles.pstatic.net/MjAxODAzMDNfMTc5/MDAxNTIwMDQxNzQwODYx.qQDg_PbRHclce0n3s-2DRePFQggeU6_0bEnxV8OY1yQg.4EZpKfKEOyW_PXOVvy7wloTrIUzb71HP8N2y-YFsBJcg.PNG.osy2201/1_%2835%ED%8D%BC%EC%84%BC%ED%8A%B8_%ED%9A%8C%EC%83%89%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w966",
            "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
            "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
            "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840",
            "https://postfiles.pstatic.net/MjAxODAzMDNfMjEz/MDAxNTIwMDQyMTEwNDIz.5VmOjx84M8Z39Bym-LC9fHRseOw8TBNRzaTx1poYm2Yg.hZ88aZCRcD7dFk1R35FD9LcAe3tbYiw-2CjenFvb45Eg.PNG.osy2201/11_%28%ED%9A%8C%EC%83%89_1%29_%ED%9A%8C%EC%83%89_%EB%8B%A8%EC%83%89_%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4_180303.png?type=w3840"
        ])
    }
    
    func loadStamps() async -> Result<[String], any Error> {
        return .success([
            "https://cdn-icons-png.flaticon.com/256/4481/4481191.png",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToaQupjlrXtCckBSuufHyena8ZgQ_CRxOxRw&s"
        ])
    }
}
