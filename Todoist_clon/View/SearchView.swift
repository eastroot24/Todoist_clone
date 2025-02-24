//
//  SearchView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var todoList: TodoListModel
    @Binding var showSheet: Bool
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
                let filteredTasks = todoList.lists.filter { task in
                    !searchText.isEmpty && (task.title?.contains(searchText) ?? false)
                }
                let groupedTasks = Dictionary(grouping: filteredTasks) { task in
                    Calendar.current.startOfDay(for: task.date)
                }
                // 🔥 날짜별 섹션으로 나눠서 검색 결과 표시
                ForEach(groupedTasks.keys.sorted(), id: \.self) { date in
                    Section(header: Text(getDate(from: date))) {
                        ForEach(groupedTasks[date] ?? []) { task in
                            todoItemRow(for: task)
                        }
                    }
                }
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
        .navigationTitle("검색")
    }
    // 📅 날짜 포맷
    func getDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    // 📝 개별 일정 항목 UI
    private func todoItemRow(for task: ListModel) -> some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    if let index = todoList.lists.firstIndex(where: { $0.id == task.id }) {
                        todoList.lists[index].isCompleted.toggle()
                    }
                }
            Text(task.title ?? "No Title")
                .strikethrough(task.isCompleted, color: .gray)
        }
    }
}

#Preview {
    SearchView(todoList: .init(), showSheet: .constant(false))}
               
