//
//  SignUpViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/16/24.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var selectedKabinettNumber: Int? = nil
    
    let kabinettNumbers = ["123-456", "234-567", "345-678"] // 1. 파베에서 사용되지 않은 넘버 3개 받기
    
    func selectKabinettNumber(at index: Int) {
        selectedKabinettNumber = index
    }
}
