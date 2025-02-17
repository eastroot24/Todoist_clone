//
//  ContentView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/15/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var todoList: TodoListModel
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            headerView
            todoListView
        }
    }
    
    // 헤더 뷰
    private var headerView: some View {
        VStack {
            HStack {
                Text("오늘")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }
            HStack {
                Text(getToday())
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    // 일정 목록 뷰
    private var todoListView: some View {
        VStack {
            if todoList.lists.isEmpty {
                noTaskView
            } else {
                List {
                    ForEach(todoList.lists.indices, id: \.self) { index in
                        todoItemRow(for: index)
                    }
                }
            }
            //AddTaskButton - 일정 추가 버튼
            AddTaskButton(todoList: todoList, showSheet: $showSheet)
        }
    }
    
    // 할 일이 없을 때의 뷰
    private var noTaskView: some View {
        ZStack {
            Image("empty_task")
                .resizable()
                .scaledToFill()
                .padding(100)
            Text("할 일이 없습니다.")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
        }
    }
    
    // 각 일정 항목 뷰
    private func todoItemRow(for index: Int) -> some View {
        HStack {
            Image(systemName: todoList.lists[index].isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todoList.lists[index].isCompleted ? .green : .gray)
                .onTapGesture {
                    todoList.lists[index].isCompleted.toggle()
                }
            Text(todoList.lists[index].title ?? "No Title")
                .strikethrough(todoList.lists[index].isCompleted, color: .gray)
        }
        .padding(5)
    }

    // MARK: - 오늘 날짜
    func getToday() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 eeee"
        let today = Date()
        return formatter.string(from: today)
    }
}

