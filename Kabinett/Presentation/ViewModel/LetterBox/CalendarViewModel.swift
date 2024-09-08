//
//  CalendarViewModel.swift
//  Kabinett
//
//  Created by uunwon on 8/30/24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var showCalendarView = false
    @Published var startDateFiltering = false
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var currentLetterType: LetterType = .all
}
