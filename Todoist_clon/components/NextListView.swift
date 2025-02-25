//
//  NextListView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/20/25.
//

import SwiftUI

struct NextListView: View {
    @Binding var selectedDate: Date
    @ObservedObject var todoListViewModel: TodoListViewModel
    let today = Date()
    var endDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: 2, to: today) ?? Date()
    }
    var body: some View {
        ScrollViewReader { proxy in
            todoListView(proxy: proxy)
            
        }
    }
    
    
    // 일정 목록 뷰
    func todoListView(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            VStack(alignment: .leading){
                // 오늘 이전 업무
                // 오늘날짜를 완전히 제외 시킨다.(!Calendar.current.isDateInToday($0.date))
                let pastItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                    guard let date = item.date else { return nil } // ✅ date가 nil이면 제거
                    return date < today && !Calendar.current.isDateInToday(date) ? item : nil
                }
                if !pastItems.isEmpty {
                    Section(header: Text("기간 지난 업무")){
                        ForEach(pastItems) { task in
                            todoItemRow(for: task)
                        }
                    }
                    
                }
                //오늘 업무
                let todayItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                    guard let date = item.date else{ return nil }
                    return Calendar.current.isDate(date, inSameDayAs: today) ? item : nil
                }
                //미래 업무
                let futureItems = todoListViewModel.todoItems.compactMap { item -> TodoItem? in
                    guard let date = item.date else { return nil } // ✅ date가 nil이면 제거
                    return date >= today ? item : nil
                }
                ForEach(datesInRange(), id: \.self) { date in
                    let yearDate = getYear(from: date) + getDate(from: date)
                    VStack(alignment: .leading) {
                        if (getYear(from: date) != getYear(from: today)){
                            Text(yearDate).id(getDate(from: date))
                        }
                        if getYear(from: date) == getYear(from: today) {
                            Text(getDate(from: date)).id(getDate(from: date))
                        }
                        Divider()
                        //오늘 업무
                        if date == today {
                            ForEach(todayItems) { task in
                                todoItemRow(for: task)
                            }
                        }else if date > today{
                            //미래 업무
                            ForEach(futureItems) { task in
                                if Calendar.current.isDate(task.date!, inSameDayAs: date) {
                                    todoItemRow(for: task)
                                }
                            }
                        }
                    }
                }
            }
                .onChange(of: selectedDate) {
                    withAnimation {
                        let targetDate = getDate(from: selectedDate)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(targetDate, anchor: .top)
                                }
                    }
                }
            
        }
    }
    
    func datesInRange() -> [Date] {
        var dates: [Date] = []
        var currentDate = today
        let calendar = Calendar.current
        
        // startDate부터 endDate까지 하루씩 증가시키며 날짜 리스트 생성
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    // 각 일정 항목 뷰
    private func todoItemRow(for task: TodoItem) -> some View{
        let taskDate = getDate(from: task.date!)
        //중복 항목 필터링
        return HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    if todoListViewModel.todoItems.firstIndex(where: { $0.id == task.id }) != nil {
                        todoListViewModel.deleteItem(item: task)
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
    func getYear(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년"
        return formatter.string(from: date)
    }
}


