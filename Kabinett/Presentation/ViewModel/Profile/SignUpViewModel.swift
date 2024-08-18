//
//  SignUpViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/16/24.
//

import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    private let useCase: any SignupUseCase
    @Published var userName: String = ""
    @Published var kabinettNumbers: [String] = []
    @Published var selectedKabinettNumber: Int? = nil
    
    init(useCase: any SignupUseCase) {
        self.useCase = useCase
    }
    
    @MainActor
    func getNumbers() async {
        let numbers = await useCase.getAvailableKabinettNumbers()
        kabinettNumbers = numbers
            .map {
                formatNumber($0)
            }
    }
    private func formatNumber(_ number: Int) -> String {
        let formattedNumber = String(format: "%06d", number)
        let startIndex = formattedNumber.index(formattedNumber.startIndex, offsetBy: 3)
        let part1 = formattedNumber[..<startIndex]
        let part2 = formattedNumber[startIndex...]
        
        return "\(part1)-\(part2)"
    }
}
