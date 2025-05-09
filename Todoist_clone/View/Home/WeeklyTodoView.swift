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
                            TimeLineBackground(hourHeight: hourHeight)

                            // ⏱️ 현재 시간 파란선
                            CurrentTimeLineView(currentDate: context.date)
                                .offset(y: offsetForTime(context.date) + 2) // ✔️ 위치 보정

                            // 📝 할 일 카드
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
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)

        let fractional = CGFloat(minute * 60 + second) / 3600.0
        return (CGFloat(hour) + fractional) * hourHeight
    }

    private var tasksForSelectedDate: [TodoItem] {
        todoListViewModel.todoItems.filter {
            guard let date = $0.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: selectedDate)
        }
    }

    @ViewBuilder
    private func taskCardsOverlay() -> some View {
        ForEach(tasksForSelectedDate) { task in
            if let date = task.date {
                TaskCardView(task: task)
                    .padding(.leading, 60)
                    .offset(y: offsetForTime(date))
            }
        }
    }
}






