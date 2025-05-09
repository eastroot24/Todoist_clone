//
//  WeeklyTodoTabView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//

import SwiftUI

struct WeekdayTabView: View {
    @Binding var selectedDate: Date
    private let weekDates: [Date] = {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: today) else {
            return []
        }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(weekDates, id: \.self) { date in
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    VStack {
                        Text(formattedDate(date, format: "E"))
                            .font(.subheadline)
                            .foregroundColor(isSelected ? .white : .primary)
                        Text(formattedDate(date, format: "d"))
                            .font(.headline)
                            .foregroundColor(isSelected ? .white : .primary)
                    }
                    .padding(8)
                    .background(isSelected ? Color.blue : Color.clear)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func formattedDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
