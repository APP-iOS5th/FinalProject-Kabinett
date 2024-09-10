//
//  Extension+String.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import Foundation

extension String {
    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }
}
