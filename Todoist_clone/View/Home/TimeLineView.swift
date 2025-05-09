//
//  TimeLineView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//

import SwiftUI

struct TimeLineView: View {
    let selectedDate: Date
    let tasks: [TodoItem]
    
    let hourHeight: CGFloat = 100  // 각 시간 높이 조절

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { hour in
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        Text(String(format: "%02d:00", hour))
                            .font(.caption)
                            .frame(width: 50, alignment: .trailing)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    .frame(height: hourHeight, alignment: .top)

                    // 해당 시간에 해당하는 할 일 표시
                    ForEach(tasksForHour(hour), id: \.id) { task in
                        TaskCardView(task: task)
                            .offset(y: offsetWithinHour(for: task.date!))
                            .padding(.leading, 60)
                    }
                }
            }
        }
    }

    private func tasksForHour(_ hour: Int) -> [TodoItem] {
        tasks.filter { item in
            guard let date = item.date else { return false }
            let taskHour = Calendar.current.component(.hour, from: date)
            return taskHour == hour
        }
    }

    // 해당 시간 내 분 위치 조절 (ex. 15:30은 50pt)
    private func offsetWithinHour(for date: Date) -> CGFloat {
        let minute = Calendar.current.component(.minute, from: date)
        return CGFloat(minute) / 60.0 * hourHeight
    }
}


