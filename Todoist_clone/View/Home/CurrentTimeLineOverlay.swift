//
//  CurrentTimeLineOverlay.swift
//  Todoist_clone
//
//  Created by eastroot on 5/13/25.
//

import SwiftUI

struct CurrentTimeLineOverlay: View {
    let offsetY: CGFloat
    let currentDate: Date

    var body: some View {
        HStack(spacing: 4) {
            Text(currentTimeFormatted)
                .font(.caption2)
                .foregroundColor(.red)
                .frame(width: 45, alignment: .trailing)

            Circle()
                .fill(Color.red)
                .frame(width: 6, height: 6)

            Rectangle()
                .fill(Color.red)
                .frame(height: 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .id("currentTime")
        }
        .offset(y: offsetY)
    }

    private var currentTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentDate)
    }
}
