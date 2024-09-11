//
//  CalendarView.swift
//  Kabinett
//
//  Created by uunwon on 8/21/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var letterBoxDetailviewModel: LetterBoxDetailViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    @State private var selectedStartDate = Date()
    @State private var selectedEndDate = Date()
    
    @State private var showGraphicalStartCalendar = false
    @State private var showGraphicalEndCalendar = false

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            calendarViewModel.showCalendarView.toggle()
                        }
                    } label: {
                        Text("취소")
                            .font(.system(size: 17))
                            .foregroundStyle(.contentPrimary)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            calendarViewModel.startDate = selectedStartDate
                            calendarViewModel.endDate = selectedEndDate
                            calendarViewModel.showCalendarView.toggle()
                            
                            letterBoxDetailviewModel.fetchSearchByDate(letterType: calendarViewModel.currentLetterType, startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate)
                            
                            if !calendarViewModel.startDateFiltering {
                                calendarViewModel.startDateFiltering.toggle()
                            }
                        }
                    } label: {
                        Text("확인")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.contentPrimary)
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("시작")
                        .foregroundStyle(.contentPrimary)
                    
                    Spacer()
                    
                    Text("\(formattedDate(date: selectedStartDate))")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 6)
                        .background(.primary600.opacity(0.1))
                        .cornerRadius(7)
                        .onTapGesture {
                            withAnimation {
                                showGraphicalStartCalendar.toggle()
                                
                                if showGraphicalEndCalendar {
                                    showGraphicalEndCalendar.toggle()
                                }
                            }
                        }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)

                if showGraphicalStartCalendar {
                    Divider()
                        .padding(.leading, 20)
                    
                    DatePicker("시작", selection: Binding(get: { self.selectedStartDate }, set: { newValue in
                        self.selectedStartDate = newValue
                        self.validateStartDate()
                    }), in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.top, -10)
                        .padding(.horizontal, 10)
                        .tint(.primary900)
                        .padding(.bottom, -10)
                }
                
                Divider()
                    .padding(.leading, 20)

                HStack {
                    Text("종료")
                        .foregroundStyle(.contentPrimary)
                    
                    Spacer()
                    
                    Text("\(formattedDate(date: selectedEndDate))")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 6)
                        .background(.primary600.opacity(0.1))
                        .cornerRadius(7)
                        .onTapGesture {
                            withAnimation {
                                showGraphicalEndCalendar.toggle()
                                
                                if showGraphicalStartCalendar {
                                    showGraphicalStartCalendar.toggle()
                                }
                            }
                        }
                }
                .padding(.bottom, showGraphicalEndCalendar ? 0 : 10)
                .padding(.horizontal, 20)

                if showGraphicalEndCalendar {
                    Divider()
                        .padding(.leading, 20)
                    
                    DatePicker("종료", selection: Binding(get: { self.selectedEndDate }, set: { newValue in
                        self.selectedEndDate = newValue
                        self.validateEndDate()
                    }), in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.top, -10)
                        .padding(.horizontal, 10)
                        .tint(.primary900)
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            
            Spacer()
        }
        .onAppear {
            if calendarViewModel.startDateFiltering {
                selectedStartDate = calendarViewModel.startDate
                selectedEndDate = calendarViewModel.endDate
            } else {
                selectedStartDate = Date()
                selectedEndDate = Date()
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter.string(from: date)
    }
    
    private func validateStartDate() {
        if selectedStartDate > selectedEndDate {
            selectedEndDate = selectedStartDate
        }
    }
    
    private func validateEndDate() {
        if selectedEndDate < selectedStartDate {
            selectedStartDate = selectedEndDate
        }
    }
}

struct CalendarOverlayView: View {
    @EnvironmentObject var calendarViewModel: CalendarViewModel

    var body: some View {
        if calendarViewModel.showCalendarView {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            calendarViewModel.showCalendarView = false
                        }
                    }
                
                CalendarView()
                    .cornerRadius(20)
                    .padding(.top, 32)
            }
        }
    }
}

struct CalendarBar: View {
    @EnvironmentObject var letterBoxDetailviewModel: LetterBoxDetailViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: UIScreen.main.bounds.width * 0.01) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: UIScreen.main.bounds.width * 0.042))
                    
                    Text("\(formattedDate(date: calendarViewModel.startDate))부터 \(formattedDate(date: calendarViewModel.endDate))까지")
                        .font(.system(size: UIScreen.main.bounds.width * 0.037))
                        .foregroundStyle(.contentSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 0)
                }
                .padding(UIScreen.main.bounds.width * 0.02)
                .padding(.vertical, UIScreen.main.bounds.width * 0.002)
                .foregroundStyle(.contentSecondary)
                .background(.primary300.opacity(0.3))
                .background(TransparentBlurView(removeAllFilters: false))
                .cornerRadius(UIScreen.main.bounds.width * 0.027)
                
                Button(action: {
                    withAnimation {
                        calendarViewModel.startDateFiltering.toggle()
                        calendarViewModel.startDate = Date()
                        calendarViewModel.endDate = Date()
                        letterBoxDetailviewModel.fetchLetterBoxDetailLetters(letterType: calendarViewModel.currentLetterType)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.primary600)
                        .font(.system(size: UIScreen.main.bounds.width * 0.045))
                }
            }
            .padding(.top, UIScreen.main.bounds.width * 0.01)
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMM d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
