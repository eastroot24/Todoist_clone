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
    let today = Date()
    
    var body: some View {
        VStack {
            headerView
            todoListView()
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
                Text(getDate(from: Date()))
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
    //
    
    // 일정 목록 뷰
    func todoListView() -> some View {
        VStack {
            if todoList.lists.isEmpty {
                noTaskView
            }
            else{
                List{
                    // 오늘 이전 업무
                    // 오늘날짜를 완전히 제외 시킨다.(!Calendar.current.isDateInToday($0.date))
                    let pastItems = todoList.lists.filter { $0.date < today && !Calendar.current.isDateInToday($0.date)  }
                    if !pastItems.isEmpty {
                        Section(header: Text("기간 지난 업무")){
                            ForEach(pastItems) { task in
                                todoItemRow(for: task)
                            }
                        }
                        
                    }
                    //오늘 업무
                    let todayItems = todoList.lists.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
                    if !todayItems.isEmpty{
                        Section(header: Text("오늘의 업무")){
                            ForEach(todayItems) { task in
                                todoItemRow(for: task)
                            }
                        }
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
    private func todoItemRow(for task: ListModel) -> some View{
        let taskDate = getDate(from: task.date)
        //중복 항목 필터링
        return HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .onTapGesture {
                        if let index = todoList.lists.firstIndex(where: { $0.id == task.id }) {
                                todoList.lists[index].isCompleted.toggle()
                            }
                    }
                Text(task.title ?? "No Title")
                .strikethrough(task.isCompleted, color: .gray)
                Text(taskDate)
            }
            .padding(5)
    }
    
    // MARK: - 오늘 날짜
    func getDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 eeee"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView(todoList: .init(), showSheet: .constant(false))
}
