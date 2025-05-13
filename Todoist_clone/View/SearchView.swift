//
//  SearchView.swift
//  Todoist_clone
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    @State private var searchText = "" // 🔍 검색어
    
    
    var body: some View {
        VStack {
            HStack {
                Text("검색")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                Spacer()
            }
            // 🔍 검색 입력란
            HStack {
                TextField("작업, 프로젝트 및 기타", text: $searchText)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        HStack{
                            Spacer()
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing)
                            }
                        }
                            .padding()
                    )
                if !searchText.isEmpty{
                    Button {
                        searchText = ""
                    } label: {
                        Text("취소")
                    }
                    .padding()
                }
                
            }
            
            // 📝 검색 결과 리스트
            List {
                let filteredTasks = filteredTodoItems()
                let groupedTasks = groupTasksByDate(filteredTasks)
                
                // 🔥 날짜별 섹션으로 나눠서 검색 결과 표시
                ForEach(groupedTasks.keys.sorted(), id: \.self) { date in
                    Section(header: Text(getDate(from: date))) {
                        ForEach(groupedTasks[date] ?? []) { task in
                            todoListViewModel.todoItemRow(for: task)
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .overlay(
                VStack{
                    Spacer()
                    //AddTaskButton - 일정 추가 버튼
                    AddTaskButton(todoListViewModel: todoListViewModel)
                        .padding(.vertical, 20)
                }
            )
            
        }
        .navigationTitle("검색")
        .background(Color("BackgroundColor"))
    }
    
    // 📅 날짜 포맷
    func getDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }

    // 📝 필터링된 작업들
    private func filteredTodoItems() -> [TodoItem] {
        return todoListViewModel.todoItems.filter { task in
            !searchText.isEmpty && (task.title?.contains(searchText) ?? false)
        }
    }
    
    // 📅 날짜별로 작업 그룹화
    private func groupTasksByDate(_ tasks: [TodoItem]) -> [Date: [TodoItem]] {
        return Dictionary(grouping: tasks) { task in
            if let date = task.date {
                return Calendar.current.startOfDay(for: date)
            } else {
                return Date()
            }
        }
    }
}
