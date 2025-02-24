//
//  NextView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct NextView: View {
    @ObservedObject var todoList: TodoListModel
    @Binding var showSheet: Bool
    @State private var selectedDate: Date = Date()
    var body: some View {
        VStack{
                    Text("다음")
                        .font(.title)
                        .fontWeight(.bold)
                NextCalendar(selectedDate: $selectedDate)
                NextListView(selectedDate: $selectedDate, todoList: todoList)
                }
        .overlay(
            VStack{
                Spacer()
                //AddTaskButton - 일정 추가 버튼
                AddTaskButton(todoList: todoList, showSheet: $showSheet)
                    .padding(.vertical, 20)
            }
        )
    
    }
}
