//
//  WeeklyTodoView.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//
import SwiftUI

struct WeeklyTodoView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    @State private var selectedDate: Date = Date()
    @State private var didScrollToCurrentTime = false
    
    let hourHeight: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 0) {
            WeekdayTabView(selectedDate: $selectedDate)
                .padding(.vertical, 8)
            
            Divider()
            
            TimelineView(.periodic(from: .now, by: 60)) { context in
                ScrollViewReader { proxy in
                    ScrollView {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                ForEach(0..<24) { hour in
                                    TimelineRowView(
                                        hour: hour,
                                        hourHeight: hourHeight,
                                        currentDate: context.date
                                    )
                                }
                            }
                            
                            // 📝 할 일 카드들
                            taskCardsOverlay()
                        }
                        .frame(height: hourHeight * 24)
                        .id("timelineRoot")
                        .onAppear {
                            if !didScrollToCurrentTime {
                                // ⏰ 약간의 딜레이 후 스크롤 트리거
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        proxy.scrollTo("currentTime", anchor: .center)
                                    }
                                    didScrollToCurrentTime = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("주간 할 일")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func offsetForTime(_ date: Date) -> CGFloat {
        let calendar = Calendar.current
        let hour = CGFloat(calendar.component(.hour, from: date))
        let minute = CGFloat(calendar.component(.minute, from: date))
        let second = CGFloat(calendar.component(.second, from: date))
        
        let totalHours = hour + (minute / 60.0) + (second / 3600.0)
        return totalHours * hourHeight
    }
    
    
    private var tasksForSelectedDate: [TodoItem] {
        todoListViewModel.todoItems.filter {
            guard let date = $0.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: selectedDate)
        }
    }
    
    @ViewBuilder
    private func taskCardsOverlay() -> some View {
        let sortedTasks = tasksForSelectedDate.sorted {
            guard let d1 = $0.date, let d2 = $1.date else { return false }
            return d1 < d2
        }

        let spacing: CGFloat = 8
        let cardHeight: CGFloat = 60
        @State var lastYOffset: CGFloat = -1000 // 여기서 상태로 선언

        ForEach(Array(sortedTasks.enumerated()), id: \.element.id) { index, task in
            if let date = task.date {
                let baseY = offsetForTime(date)

                let yOffset: CGFloat = (baseY < lastYOffset + cardHeight + spacing)
                    ? lastYOffset + cardHeight + spacing
                    : baseY

                let reallastYOffset = yOffset

                TaskCardWithOffsetView(task: task, yOffset: reallastYOffset)
            }
        }
    }




    private func groupTasksWithoutOverlap(_ tasks: [TodoItem]) -> [[TodoItem]] {
        let sortedTasks = tasks.sorted {
            guard let d1 = $0.date, let d2 = $1.date else { return false }
            return d1 < d2
        }

        var groups: [[TodoItem]] = []
        var currentGroup: [TodoItem] = []

        for task in sortedTasks {
            guard let taskDate = task.date else { continue }
            if currentGroup.isEmpty {
                currentGroup.append(task)
            } else {
                // 이전 항목과의 시간 차이로 겹치는지 판단 (예: 30분 이내면 겹침으로 간주)
                if let lastDate = currentGroup.last?.date,
                   abs(taskDate.timeIntervalSince(lastDate)) < 1800 { // 1800초 = 30분
                    currentGroup.append(task)
                } else {
                    groups.append(currentGroup)
                    currentGroup = [task]
                }
            }
        }

        if !currentGroup.isEmpty {
            groups.append(currentGroup)
        }

        return groups
    }


}






