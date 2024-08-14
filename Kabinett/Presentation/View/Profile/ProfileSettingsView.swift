//
//  ProfileSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    @State private var userName = "Yule"
    @State private var newUserName = ""
    
    let kabinettNumber = "000-000"
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .foregroundColor(.primary300)
                    .frame(width: 110)
                Image(systemName: "camera")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }) {
                    Text("완료")
                        .font(.system(size: 16))
                        .foregroundColor(.contentPrimary)
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
}
#Preview {
    ProfileSettingsView()
}
