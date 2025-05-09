//
//  CurrentTimeLineView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//
import SwiftUI

struct CurrentTimeLineView: View {
    let currentDate: Date

    var body: some View {
        HStack(spacing: 4) {
            Text(currentTimeFormatted)
                .font(.caption2)
                .foregroundColor(.blue)
                .frame(width: 45, alignment: .trailing)

            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)

            Rectangle()
                .fill(Color.blue)
                .frame(height: 1)
        }
        .id("currentTime")
    }

    private var currentTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentDate)
    }
}




