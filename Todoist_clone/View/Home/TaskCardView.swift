//
//  TaskCardView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//

import SwiftUI

struct TaskCardView: View {
    let task: TodoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(task.title ?? "")
                    .font(.headline)
                Spacer()
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            HStack{
                Text(task.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                if let todoDate = task.date{
                    Text(formatDateToTimeString(todoDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
            }
            
        }
        .padding()
        .background(Color.yellow.opacity(0.3))
        .cornerRadius(8)
        .frame(maxWidth: 250, alignment: .leading)
    }
    func formatDateToTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // 또는 "ko_KR" 원하면
        formatter.dateFormat = "h:mm a" // 또는 "a h:mm" → 예: "오후 3:53"
        return formatter.string(from: date)
    }
}

