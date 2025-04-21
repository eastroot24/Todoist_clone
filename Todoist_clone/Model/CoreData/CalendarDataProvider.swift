//
//  CalendarDataProvider.swift
//  Todoist_clone
//
//  Created by eastroot on 4/20/25.
//
import Foundation
import CoreData
import FirebaseFirestore
import FirebaseAuth

class CalendarDataProvider {
    let context: NSManagedObjectContext
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid
    private var persistenceController = PersistenceController.shared
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // ✅ 한 달간 Todo + Diary Preview 추출
    func fetchCalendarPreview(forMonth date: Date) async -> [CalendarPreviewData] {
        let todos = fetchTodos(for: date)
        let diaries = await fetchDiaries(for: date)
        
        let calendar = Calendar.current
        var previewMap: [Date: CalendarPreviewData] = [:]
        
        // Todo 정리
        for todo in todos {
            let day = calendar.startOfDay(for: todo.date ?? Date())
            let preview = CalendarPreviewData(date: day, todoPreview: todo.title, hasDiary: false)
            previewMap[day] = preview
        }
        
        // Diary 정리
        for diaryDate in diaries {
            let day = calendar.startOfDay(for: diaryDate)
            if let existing = previewMap[day] {
                // 기존 데이터는 그대로 두고 새로운 객체로 교체
                previewMap[day] = CalendarPreviewData(date: existing.date, todoPreview: existing.todoPreview, hasDiary: true)
            } else {
                previewMap[day] = CalendarPreviewData(date: day, todoPreview: nil, hasDiary: true)
            }
        }
        
        return Array(previewMap.values)
    }
    
    private func fetchTodos(for date: Date) -> [TodoItem] {
        let todos: [TodoItem]
        todos = persistenceController.fetchTodoItems()
        return todos
    }
    
    private func fetchDiaries(for date: Date) async -> [Date] {
        guard let userId = userId else { return [] }
        
        let calendar = Calendar.current
        let start = calendar.dateInterval(of: .month, for: date)!.start
        let end = calendar.date(byAdding: .month, value: 1, to: start)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var datesWithDiary: [Date] = []
        
        let snapshot = try? await db.collection("users").document(userId).collection("diaries").getDocuments()
        
        snapshot?.documents.forEach { doc in
            if let diaryDate = formatter.date(from: doc.documentID),
               diaryDate >= start && diaryDate < end {
                datesWithDiary.append(diaryDate)
            }
        }
        
        return datesWithDiary
    }
}

