//
//  Extension.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//

import Foundation

extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    func formattedHourMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }

    func isNowBetween(start: Date, end: Date) -> Bool {
        let now = Date()
        return (start...end).contains(now)
    }
}
