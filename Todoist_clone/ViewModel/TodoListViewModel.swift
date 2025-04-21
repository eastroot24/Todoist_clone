//
//  TodoListViewModel.swift
//  Todoist_clone
//
//  Created by eastroot on 2/25/25.
//

import Foundation
import CoreData
import SwiftUI


class TodoListViewModel: ObservableObject {
    
    @Published var todoItems: [TodoItem] = [] // ✅ Core Data에서 불러온 데이터 저장
    @Published var completedItems: [TodoItem] = []
    private var persistenceController = PersistenceController.shared
    private let context = PersistenceController.shared.viewContext
    
    // 랭크 기준 (게이지 100% 기준값)
    enum RankInfo {
        static let thresholds: [(rank: String, max: Int)] = [
            ("Bronze", 10),
            ("Silver", 50),
            ("Gold", 100),
            ("Platinum", 200),
            ("Emerald", 500),
            ("Diamond", 1000),
            ("VIP", Int.max)
        ]
    }
    
    // @Published 상태 추가: 각 항목에 대해 애니메이션 상태 관리
    @Published var tappedItems: Set<NSManagedObjectID> = []
    
    init(context: NSManagedObjectContext) {
        fetchTodoItems() // 초기 데이터 로드
        fetchCompletedItems()
    }
    
    // ✅ Core Data에서 TodoItem 불러오기
    func fetchTodoItems() {
        todoItems = persistenceController.fetchTodoItems()
        
    }
    // ✅ Core Data에서 TodoItem 불러오기
    func fetchCompletedItems(){
        completedItems = persistenceController.completedFetchRequest()
    }
    
    // ✅ 새로운 TodoItem 추가
    func addItem(title: String, date: Date) {
        persistenceController.addItem(title: title, date: date)
        fetchTodoItems()
        fetchCompletedItems()
    }
    
    // ✅ 특정 TodoItem 삭제
    func deleteItem(item: TodoItem) {
        persistenceController.deleteItem(item: item)
        fetchTodoItems()
        fetchCompletedItems()
    }
    func toggleCompleted(item: TodoItem) {
        persistenceController.toggleCompletion(task: item)
        fetchTodoItems()
        fetchCompletedItems()
    }
    func deleteAllTasks() {
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        do {
            // Core Data에서 모든 TodoItem 객체 불러오기
            let items = try context.fetch(fetchRequest)
            
            // 모든 항목 삭제
            for item in items {
                context.delete(item)
            }
            
            // 변경 사항 저장
            try context.save()
            
            // 뷰 모델의 배열도 비워줍니다.
            todoItems.removeAll() // 완료되지 않은 업무 삭제
            completedItems.removeAll() // 완료된 업무 삭제
        } catch {
            print("데이터 삭제 중 오류 발생: \(error)")
        }
    }
    
    // 📝 개별 일정 항목 UI
    func todoItemRow(for task: TodoItem) -> some View {
        @State var isTapped = false
        return HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    let impact = UIImpactFeedbackGenerator(style: .light) // ✅ 가벼운 진동 효과
                    impact.impactOccurred()
                    
                    self.toggleCompleted(item: task)
                    
                }
            
            Text(task.title ?? "No Title")
            //.strikethrough(task.isCompleted, color: .gray)
        }
        .swipeActions{
            Button(role: .destructive){
                self.deleteItem(item: task)
            } label: {
                Label("삭제", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    
    func dailyCompletionStats() -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: completedItems) { item in
            calendar.startOfDay(for: item.date ?? Date())
        }
        return grouped.map { (key, value) in
            (date: key, count: value.count)
        }
        .sorted { $0.date < $1.date }
    }
    
    func weeklyCompletionStats() -> [(weekOfYear: Int, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: completedItems) { item in
            calendar.component(.weekOfYear, from: item.date ?? Date())
        }
        return grouped.map { (week, items) in
            (weekOfYear: week, count: items.count)
        }
        .sorted { $0.weekOfYear < $1.weekOfYear }
    }
    var currentYearMonthText: String {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy년 M월"
         return formatter.string(from: Date())
     }

     var currentMonthDays: [Date] {
         let calendar = Calendar.current
         let now = Date()
         guard let range = calendar.range(of: .day, in: .month, for: now),
               let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
             return []
         }

         return range.compactMap { day -> Date? in
             let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
             return date! <= now ? date : nil
         }
     }

     func filteredDailyStats() -> [(date: Date, count: Int)] {
         let fullStats = dailyCompletionStats()
         let validDates = Set(currentMonthDays)
         return fullStats.filter { validDates.contains($0.date) }
     }
    func formattedWeeklyStats() -> [(label: String, count: Int)] {
            let calendar = Calendar.current
            let now = Date()
            let year = calendar.component(.year, from: now)
            let month = calendar.component(.month, from: now)

            // 1️⃣ 이번 달의 모든 날짜들
            guard let range = calendar.range(of: .day, in: .month, for: now),
                  let startOfMonth = calendar.date(from: DateComponents(year: year, month: month)) else {
                return []
            }

            let datesInMonth = range.compactMap { day -> Date? in
                let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
                return date! <= now ? date : nil
            }

            // 2️⃣ 해당 날짜들의 (월, 주차) 라벨 추출
            let weekLabels = Set(datesInMonth.map { date in
                let weekOfMonth = calendar.component(.weekOfMonth, from: date)
                return "\(month)월 \(weekOfMonth)주"
            })

            // 3️⃣ 완료 항목들을 (월, 주차)로 그룹화
            let completedGroups = Dictionary(grouping: completedItems) { item in
                let date = item.date ?? Date()
                let itemMonth = calendar.component(.month, from: date)
                let weekOfMonth = calendar.component(.weekOfMonth, from: date)
                return "\(itemMonth)월 \(weekOfMonth)주"
            }

            // 4️⃣ 모든 주차 라벨을 기준으로 매핑 (없는 건 0)
            let result = weekLabels.map { label in
                let count = completedGroups[label]?.count ?? 0
                return (label: label, count: count)
            }
            .sorted { $0.label < $1.label }

            return result
        }
    
    //랭크 게이지
    func rankProgress(currentRank: String, currentCount: Int) -> Double {
        guard let currentIndex = RankInfo.thresholds.firstIndex(where: { $0.rank == currentRank }) else {
            return 0.0
        }
        let lowerBound = currentIndex == 0 ? 0 : RankInfo.thresholds[currentIndex - 1].max
        let upperBound = RankInfo.thresholds[currentIndex].max

        let progress = Double(currentCount - lowerBound) / Double(upperBound - lowerBound)
        return min(max(progress, 0), 1.0)
    }
    func rankProgressInfo(currentRank: String, currentCount: Int) -> (nextRank: String?, remaining: Int?) {
        guard let currentIndex = RankInfo.thresholds.firstIndex(where: { $0.rank == currentRank }) else {
            return (nil, nil)
        }
        
        if currentIndex + 1 < RankInfo.thresholds.count {
            let next = RankInfo.thresholds[currentIndex + 1]
            let remaining = max(next.max - currentCount, 0)
            return (next.rank, remaining)
        } else {
            return ("최고 랭크", 0)
        }
    }
}

