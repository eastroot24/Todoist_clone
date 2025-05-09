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
        NavigationStack{
            VStack {
                headerView
                TaskProgressView()
                taskCardView()
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
    
    
    
    @ViewBuilder
    func taskCardView() -> some View {
        let today = Date()
        
        let todayItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
            guard let date = item.date else { return nil }
            return Calendar.current.isDate(date, inSameDayAs: today) ? item : nil
        }
            .sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
        
        let pastItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
            guard let date = item.date else { return nil }
            return date < today && !Calendar.current.isDateInToday(date) ? item : nil
        }
            .sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
        
        if todayItems.isEmpty && pastItems.isEmpty {
            Text("오늘은 업무가 없습니다.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
        } else {
            VStack(alignment: .leading, spacing: 24) {
                if !todayItems.isEmpty {
                    HStack{
                        Text("오늘의 업무")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                        Spacer()
                        NavigationLink(destination: WeeklyTodoView()){
                            Text("더보기")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.gray)
                        }
                        .padding()
                    }
                   
                    taskSectionView(tasks: todayItems)
                }
                
                if !pastItems.isEmpty {
                        Text("지난 업무")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                    taskSectionView(tasks: pastItems)
                }
            }
        }
    }
    
    func taskSectionView(tasks: [TodoItem]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tasks) { task in
                        cardUIView(task: task)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    //카드 디자인
    func cardUIView(task: TodoItem) -> some View {
        let formattedDate = getDate(from: task.date ?? Date())
        return ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                HStack{
                    Text(task.title!)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .padding()
                        .foregroundColor(task.isCompleted ? Color("YellowCard"): Color("BrownCard"))
                        .onTapGesture {
                            let impact = UIImpactFeedbackGenerator(style: .light) // ✅ 가벼운 진동 효과
                            impact.impactOccurred()
                            todoListViewModel.toggleCompleted(item: task)
                        }
                }
                Text(task.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(formattedDate)
                    .font(.system(size: 14, weight: .light))
                    .padding(.bottom)
            }
            .padding(.leading)
            .frame(width: 210, height: 185)
            .background(task.isCompleted ? Color("BrownCard") : Color("YellowCard"))
            .cornerRadius(12)
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
    
    @ViewBuilder
    func TaskProgressView() -> some View {
        
        if let user = userService.currentUser {
            //랭크 표시
            VStack(alignment: .leading) {
                Text("랭크: \(user.rank)")
                    .font(.title3.bold())
                
                let completedCount = user.taskCount
                let progress = todoListViewModel.rankProgress(currentRank: user.rank, currentCount: completedCount)
                let info = todoListViewModel.rankProgressInfo(currentRank: user.rank, currentCount: completedCount)
                
                VStack(alignment: .leading) {
                    ProgressView(value: progress)
                        .tint(.blue)
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        if let nextRank = info.nextRank, let remaining = info.remaining, nextRank != "최고 랭크" {
                            Text("→ \(nextRank)까지 \(remaining)개 남음")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("최고 랭크 달성!")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
        } else {
            Text("로그인이 필요합니다.")
        }
        
        
        
        
    }
}


