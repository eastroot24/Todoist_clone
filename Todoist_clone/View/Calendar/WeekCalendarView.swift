//
//  WeekCalendarView.swift
//  Todoist_clone
//
//  Created by eastroot on 4/17/25.
//

import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    
    @State var showsheet: Bool = false
    
    var body: some View {
        let weekDates = getCurrentWeekDates(from: selectedDate)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(weekDates, id: \.self) { date in
                    VStack {
                        Text(shortWeekdayString(from: date))
                        Text(dayNumberString(from: date))
                            .fontWeight(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                        todoListView(for: date) // 👈 변경된 함수로 날짜별 렌더링
                    }
                    .padding()
                    .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedDate = date
                        showsheet.toggle()
                    }
                }

            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showsheet){
            WeeklyDetailView(selectedDate: selectedDate)
        }
    }
    
    func getCurrentWeekDates(from date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    func shortWeekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    func dayNumberString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var noTaskMiniView: some View {
        Image(systemName: "checkmark.circle")
            .foregroundColor(.gray)
    }

    // 일정 목록 뷰
    func todoListView(for date: Date) -> some View {
        let todayItems = todoListViewModel.todoItems.filter {
            guard let itemDate = $0.date else { return false }
            return Calendar.current.isDate(itemDate, inSameDayAs: date)
        }
        
        return Group {
            if todayItems.isEmpty {
                noTaskMiniView
            } else {
                VStack(alignment: .leading) {
                    ForEach(todayItems, id: \.self) { task in
                        Text(task.title ?? "제목 없음") // 미리보기 용
                            .font(.caption)
                            .lineLimit(1)
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
}
