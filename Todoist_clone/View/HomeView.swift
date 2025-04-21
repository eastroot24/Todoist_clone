//
//  ContentView.swift
//  Todoist_clone
//
//  Created by eastroot on 2/15/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    @EnvironmentObject var userService: UserService
    let today = Date()
    
    var body: some View {
        VStack {
            headerView
            if let user = userService.currentUser {
                Text("환영합니다, \(user.name)님!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("현재 등급: \(user.rank)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Text("할 일 개수: \(todoListViewModel.todoItems.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("로그인이 필요합니다.")
            }
            todoListView()
            Spacer()
        }
        .onAppear {
            userService.fetchUserInfo()
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
    
    // 일정 목록 뷰
    func todoListView() -> some View {
        VStack {
            let todayItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                guard let date = item.date else { return nil }
                return date == today ? item : nil
            }
            let pastItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                guard let date = item.date else { return nil }
                return date < today ? item : nil
            }
            if todayItems.isEmpty && pastItems.isEmpty{
                Text("오늘은 업무가 없습니다.")
            }
            else {
                List{
                    // 오늘 이전 업무
                    // 오늘날짜를 완전히 제외 시킨다.(!Calendar.current.isDateInToday($0.date))
                    let pastItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                        guard let date = item.date else { return nil } // ✅ date가 nil이면 제거
                        return date < today && !Calendar.current.isDateInToday(date) ? item : nil
                    }
                    if !pastItems.isEmpty {
                        Section(header: Text("기간 지난 업무")){
                            ForEach(pastItems) { task in
                                todoListViewModel.todoItemRow(for: task)
                            }
                        }
                    }
                    //오늘 업무
                    let todayItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                        guard let date = item.date else{ return nil }
                        return Calendar.current.isDate(date, inSameDayAs: today) ? item : nil
                    }
                    if !todayItems.isEmpty{
                        Section(header: Text("오늘의 업무")){
                            ForEach(todayItems) { task in
                                todoListViewModel.todoItemRow(for: task)
                            }
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
    
    // 할 일이 없을 때의 뷰
    private var noTaskView: some View {
        ZStack {
            Image("empty_task")
                .resizable()
                .scaledToFit()
            Text("할 일이 없습니다.")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
        }
    }
    
    // MARK: - 오늘 날짜
    func getDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 eeee"
        return formatter.string(from: date)
    }
}
