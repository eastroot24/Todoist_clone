//
//  TodoRowCardView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//

import SwiftUI

struct ToDoRowCardView: View {
    let todo: TodoItem
    let isCurrentTimeSlot: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .fill(isCurrentTimeSlot ? Color.red : Color.gray.opacity(0.3))
                .frame(width: 12, height: 12)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title ?? "제목 없음")
                    .font(.headline)
                Text(todo.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(todo.date?.formattedHourMinute() ?? "")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

