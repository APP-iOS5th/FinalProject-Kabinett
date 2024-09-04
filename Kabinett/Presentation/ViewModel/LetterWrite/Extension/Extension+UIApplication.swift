//
//  Extension+UIApplication.swift
//  Kabinett
//
//  Created by Song Kim on 8/21/24.
//

import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
