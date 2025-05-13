//
//  TimelineRowView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/13/25.
//

import SwiftUI

struct TimelineRowView: View {
    let hour: Int
    let hourHeight: CGFloat
    let currentDate: Date

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top, spacing: 4) {
                Text(String(format: "%02d:00", hour))
                    .font(.caption2)
                    .frame(width: 45, alignment: .trailing)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: hourHeight, alignment: .top)

            // 현재 시간 라인
            if isCurrentHour {
                CurrentTimeLineOverlay(
                    offsetY: offsetWithinHour,
                    currentDate: currentDate
                )
            }
        }
    }

    private var isCurrentHour: Bool {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentDate)
        return currentHour == hour
    }

    private var offsetWithinHour: CGFloat {
        let calendar = Calendar.current
        let minute = CGFloat(calendar.component(.minute, from: currentDate))
        let second = CGFloat(calendar.component(.second, from: currentDate))
        return ((minute * 60 + second) / 3600.0) * hourHeight
    }
}
