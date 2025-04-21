//
//  DayCell.swift
//  Todoist_clone
//
//  Created by eastroot on 4/17/25.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let preview: CalendarPreviewData?
    @Binding var selectedDate: Date

    var body: some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)

        VStack(alignment: .leading, spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.caption)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(4)
                .background(Circle().fill(isSelected ? Color.red : Color.clear))
                .frame(maxWidth: .infinity, alignment: .leading)

            if let todo = preview?.todoPreview {
                Text(todo)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }

            if preview?.hasDiary == true {
                Image(systemName: "book.closed.fill")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding(6)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
        .background(Color.white)
        .overlay(Rectangle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
    }
}


