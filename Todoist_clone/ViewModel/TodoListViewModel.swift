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
    
}
