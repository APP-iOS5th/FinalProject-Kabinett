//
//  Extension+Collection.swift
//  Kabinett
//
//  Created by uunwon on 9/10/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
