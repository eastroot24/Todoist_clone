//
//  NextCalendar.swift
//  Todoist_clon
//
//  Created by eastroot on 2/20/25.
//

import SwiftUI

struct NextCalendar: View {
    @State var isExpanded: Bool = false
    @Binding var selectedDate: Date
    var body: some View {
        
        // 📆 "2025년 2월" 버튼 -> 누르면 주간 뷰로 전환
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(yearMonthString(from: selectedDate))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .background(Color.blue.opacity(0.5))
                    .padding(.horizontal)
                Spacer()
            }
        }
        if isExpanded {
            // 📅 월간 뷰 (오늘부터 30일만)
            DatePicker("날짜 선택", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0])))
        } else {
            // 🔽 주간 뷰 (일주일만 표시)
            HStack {
                ForEach(getWeekDates(for: selectedDate), id: \.self) { date in
                    if isSameDay(selectedDate, date) || selectedDate < date{
                        Text(dayString(from: date))
                            .frame(width: 40, height: 40)
                            .background(isSameDay(date, selectedDate) ? Color.blue : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                            .foregroundStyle(Color.black)
                    } else {
                        Text(dayString(from: date))
                            .frame(width: 40, height: 40)
                            .background(isSameDay(date, selectedDate) ? Color.blue : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
    }
}


// 📆 YYYY년 MM월 형태의 문자열 반환
private func yearMonthString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월"
    return formatter.string(from: date)
}
//일주일 날짜 얻는 함수
func getWeekDates(for date: Date) -> [Date] {
       let calendar = Calendar.current
       let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
       return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
   }
// 🗓️ 요일 문자열 변환
   func dayString(from date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateFormat = "dd E" // 월, 화, 수 ...
       formatter.locale = Locale(identifier: "ko_KR")
       return formatter.string(from: date)
   }
// 오늘과 같은 날인지 확인
func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

