//
//  StationerySelectionViewModel.swift
//  Kabinett
//
//  Created by Song Kim on 8/19/24.
//

import Foundation
import SwiftUI

class StationerySelectionViewModel: ObservableObject {
    @Published var showModal = true
    @Published var selectedIndex: (Int, Int) = (0, 0)
    @Published var stationerys: [String] = []
    
    private let storageManager = FirebaseStorageManager()
    
    init() {
        Task {
            await loadStationeries()
        }
    }
    
    var numberOfRows: Int {
        (stationerys.count + 1) / 2
    }
    
    func index(row: Int, column: Int) -> Int {
        return row * 2 + column
    }
    
    func selectStationery(coordinates: (Int, Int)) {
        selectedIndex = coordinates
    }
    
    func isSelected(coordinates: (Int, Int)) -> Bool {
        return selectedIndex == coordinates
    }
    
    @MainActor
    func loadStationeries() async {
        let result = await storageManager.loadStationeries()
        switch result {
        case .success(let urls):
            DispatchQueue.main.async {
                self.stationerys = urls
            }
        case .failure(let error):
            print("Failed to load stationeries: \(error.localizedDescription)")
        }
    }
}
