//
//  LetterWritingView.swift
//  Kabinett
//
//  Created by 김정우 on 8/19/24.
//

import SwiftUI

struct LetterWritingView: View {
    let selectedImages: [IdentifiableImage]
    
    @State private var toUserId = "Y(나)"
    @State private var fromUserId = "Y(나)"
    @State private var toUserSearch = ""
    @State private var fromUserSearch = ""
    @State private var date = Date()
    @State private var showDatePicker = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary300").edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    userField(title: "보내는 사람", value: $fromUserId, search: $fromUserSearch)
                    userField(title: "받는 사람", value: $toUserId, search: $toUserSearch)
                    dateField()
                    Spacer()
                }
                .padding([.leading, .trailing], 24)
                .padding(.top, 20)
            }
            .navigationBarItems(trailing: Button("완료") {
                dismiss()
            })
        }
    }
    
    private func userField(title: String, value: Binding<String>, search: Binding<String>) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Text(title)
                    .foregroundStyle(Color("ContentPrimary"))
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 90, alignment: .leading)
                
                TextField("", text: value)
                    .foregroundStyle(Color("ContentSecondary"))
                    .font(.system(size: 15))
                    .padding(.horizontal, 15)
                    .frame(height: 40)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 10) {
                Spacer()
                    .frame(width: 90)
                UserSearchBar(text: search)
            }
        }
    }
    
    private func dateField() -> some View {
        HStack(spacing: 10) {
            Text("받을/보낼 날짜")
                .foregroundStyle(Color("ContentPrimary"))
                .font(.system(size: 16, weight: .bold))
                .frame(width: 90, alignment: .leading)
            
            Button(action: {
                showDatePicker = true
            }) {
                Text(dateFormatter.string(from: date))
                    .foregroundStyle(Color("ContentSecondary"))
                    .font(.system(size: 15))
                    .padding(.horizontal, 15)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(width: 350, height: 330)
            }
            .presentationDetents([.height(450)])
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
}

struct UserSearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("ContentPrimary"))
            TextField("검색", text: $text)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 15)
        .frame(height: 40)
        .background(Color.white)
        .clipShape(Capsule())
    }
}
