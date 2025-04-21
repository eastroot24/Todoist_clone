//
//  CalendarView.swift
//  Todoist_clone
//
//  Created by eastroot on 4/17/25.
//

import SwiftUI
import CoreData


enum CalendarMode {
    case week, month
}

struct CalendarView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    @State private var selectedMode: CalendarMode = .week
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack {
            Picker("Mode", selection: $selectedMode) {
                Text("주간").tag(CalendarMode.week)
                Text("월간").tag(CalendarMode.month)
            }
            .pickerStyle(.segmented)
            .padding()

            if selectedMode == .week {
                WeekCalendarView(selectedDate: $selectedDate)
            } else {
                MonthCalendarView(context: context)
            }
            Spacer()
        }
        .overlay(
            VStack{
                Spacer()
                //AddTaskButton - 일정 추가 버튼
                AddTaskButton(todoListViewModel: todoListViewModel)
                    .padding(.vertical, 20)
            }
        )
    }
}



