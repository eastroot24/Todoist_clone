//
//  WeeklyDetailView.swift
//  Todoist_clone
//
//  Created by eastroot on 4/20/25.
//

import SwiftUI

struct WeeklyDetailView: View {
    let selectedDate: Date
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    
    var body: some View {
        let itemsForSelectedDate = todoListViewModel.todoItems.filter {
            guard let date = $0.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: selectedDate)
        }
        
        VStack(alignment: .leading) {
            Text(formattedDate(selectedDate))
                .font(.title3)
                .bold()
                .padding(.horizontal)
            
            if itemsForSelectedDate.isEmpty {
                noTaskView
            } else {
                List {
                    ForEach(itemsForSelectedDate) { task in
                        todoListViewModel.todoItemRow(for: task)
                    }
                }
                .listStyle(.plain)
            }
            Divider()
            DiaryViewInCal(diaryViewModel: _diaryViewModel, selectedDate: selectedDate)
        }
        .padding()
    }
    
    private var noTaskView: some View {
        VStack {
            Spacer()
            Image("empty_task") // or system image
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding()
            Text("할 일이 없습니다.")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter.string(from: date)
    }
}
