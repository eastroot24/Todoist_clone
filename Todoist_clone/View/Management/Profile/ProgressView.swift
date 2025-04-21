//
//  ManageDetailView.swift
//  Todoist_clone
//
//  Created by eastroot on 3/4/25.
//
import SwiftUI
import Charts

struct DailyProgressView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    @State private var selectedDate: Date?

    var body: some View {
        let data = viewModel.filteredDailyStats()

        VStack(alignment: .leading) {
            Text(viewModel.currentYearMonthText)
                .font(.title2.bold())
                .padding(.horizontal)

            ScrollView(.horizontal) {
                Chart {
                    ForEach(data, id: \.date) { entry in
                        BarMark(
                            x: .value("날짜", entry.date, unit: .day),
                            y: .value("완료 수", entry.count)
                        )
                        .foregroundStyle(.green)

                        if selectedDate == entry.date {
                            PointMark(
                                x: .value("날짜", entry.date),
                                y: .value("완료 수", entry.count)
                            )
                            .annotation(position: .top) {
                                Text("\(entry.count)개")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    }
                }
                .chartXSelection(value: $selectedDate)
                .frame(width: CGFloat(viewModel.currentMonthDays.count) * 30, height: 250)
                .padding(.vertical)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.day(.defaultDigits))
                    }
                }
            }
        }
    }
}



struct WeeklyProgressView: View {
    @EnvironmentObject var viewModel: TodoListViewModel
    @State private var selectedLabel: String?

    var body: some View {
        let data = viewModel.formattedWeeklyStats()

        VStack(alignment: .leading) {
            Text(viewModel.currentYearMonthText)
                .font(.title2.bold())
                .padding(.horizontal)

            Chart {
                ForEach(data, id: \.label) { entry in
                    LineMark(
                        x: .value("주", entry.label),
                        y: .value("완료 수", entry.count)
                    )
                    .symbol(Circle())

                    if selectedLabel == entry.label {
                        PointMark(
                            x: .value("주", entry.label),
                            y: .value("완료 수", entry.count)
                        )
                        .annotation(position: .top) {
                            Text("\(entry.count)개")
                                .font(.caption)
                                .padding(5)
                                .background(Color.white.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }
            }
            .frame(height: 250)
            .padding()
        }
    }
}

