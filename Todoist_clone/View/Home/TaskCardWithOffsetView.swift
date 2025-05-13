//
//  TaskCardWithOffsetView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/13/25.
//

import SwiftUI

struct TaskCardWithOffsetView: View {
    let task: TodoItem
    let yOffset: CGFloat

    var body: some View {
        TaskCardView(task: task)
            .padding(.leading, 60)
            .offset(y: yOffset)
    }
}
