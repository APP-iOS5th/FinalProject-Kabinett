//
//  CustomTabView.swift
//  Kabinett
//
//  Created by 김정우 on 8/13/24.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var showOptions = false
    @State private var showActionSheet = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                LetterBoxView()
                    .tabItem {
                        Image(systemName: "tray.full")
                        Text("받은편지")
                    }
                    .tag(0)
                Color.clear
                    .tabItem {
                        Image(systemName: "plus")
                    }
                    .tag(1)
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("프로필")
                    }
                    .tag(2)
            }
            .onChange(of: selectedTab) { previousTap, currentTap in
                if currentTap == 1 {
                    withAnimation {
                        showOptions = true
                    }
                    selectedTab = previousTap
                }
            }
            
            if showOptions {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation{
                            showOptions = false
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 1) {
                        Button(action: {
                            // 편지 불러오기 동작
                            showOptions = false
                            showActionSheet = true
                        }) {
                            Text("편지 불러오기")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                        }
                        Button(action: {
                            print("편지쓰기 이동")
                            showOptions = false
                        }) {
                            Text("편지 쓰기")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                        }
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, getSafeAreaBottom() + 25)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("편지를 불러올 방법을 선택하세요."),
                buttons: [
                    .default(Text("촬영하기")),
                    .default(Text("앨범에서 가져오기")),
                    .cancel(Text("취소"))
                ]
            )
        }
    }
}


func getSafeAreaBottom() -> CGFloat {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    return windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
}


// sample view
struct LetterBoxView: View {
    var body: some View {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                Text("받은 편지")
            }
        }
    }
}


struct ProfileView: View {
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                Text("프로필")
            }
        }
    }
}


struct WriteLetterView: View {
    var body: some View {
        Text("이곳에서 편지를 작성하세요!")
            .padding()
            .navigationTitle("편지 쓰기")
    }
}

#Preview {
    CustomTabView()
}
