//
//  MonthCalendarView.swift
//  Todoist_clone
//
//  Created by eastroot on 4/17/25.
//

import SwiftUI
import CoreData

struct MonthCalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker = false
    @State private var showModal = false

    @GestureState private var dragOffset: CGFloat = 0
    @StateObject private var viewModel: MonthCalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MonthCalendarViewModel(context: context))
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(formattedMonth(date: currentMonth))
                    .font(.title3.bold())
                    .onTapGesture {
                        showDatePicker.toggle()
                    }
                Spacer()
            }
            .padding(.vertical, 8)

            if showDatePicker {
                UIKitMonthYearPicker(selectedDate: $currentMonth)
                    .frame(height: 200)
                    .onChange(of: currentMonth) { newDate in
                        selectedDate = newDate
                        Task { await viewModel.load(for: newDate) }
                        showDatePicker = false
                    }
            }

            let days = generateDaysForMonth()

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(days, id: \.self) { date in
                    let preview = viewModel.preview(for: date)
                    DayCell(date: date, preview: preview, selectedDate: $selectedDate)
                        .onTapGesture {
                            selectedDate = date
                            showModal = true
                        }
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset, body: { value, state, _ in
                        state = value.translation.width
                    })
                    .onEnded { value in
                        if value.translation.width < -50 {
                            changeMonth(by: 1)
                        } else if value.translation.width > 50 {
                            changeMonth(by: -1)
                        }
                    }
            )
        }
        .sheet(isPresented: $showModal) {
            // TODO: Detail 뷰 연결
            WeeklyDetailView(selectedDate: selectedDate)
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.load(for: currentMonth)
            }
        }
    }

    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
            selectedDate = newDate
            Task {
                await viewModel.load(for: newDate)
            }
        }
    }

    private func formattedMonth(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    private func formattedDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func generateDaysForMonth() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 월요일 시작

        let current = calendar.dateInterval(of: .month, for: currentMonth)!
        let startOfMonth = current.start
        let startWeekday = calendar.component(.weekday, from: startOfMonth)
        let offset = (startWeekday - calendar.firstWeekday + 7) % 7

        var days: [Date] = []
        for i in -offset..<calendar.range(of: .day, in: .month, for: currentMonth)!.count {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfMonth) {
                days.append(day)
            }
        }

        return days
    }
}


