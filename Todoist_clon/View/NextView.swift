//
//  NextView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct NextView: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    @Binding var showSheet: Bool
    @State private var selectedDate: Date = Date()
    var body: some View {
        VStack{
            Text("다음")
                .font(.title)
                .fontWeight(.bold)
            NextCalendar(selectedDate: $selectedDate)
            NextListView(selectedDate: $selectedDate, todoListViewModel: todoListViewModel)
        }
        .overlay(
            VStack{
                Spacer()
                //AddTaskButton - 일정 추가 버튼
                AddTaskButton(todoListViewModel: todoListViewModel, showSheet: $showSheet)
                    .padding(.vertical, 20)
            }
        )
        
    }
}
