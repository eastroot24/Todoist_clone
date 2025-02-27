//
//  Persistence.swift
//  Todoist_clon
//
//  Created by eastroot on 2/25/25.
//

import Foundation
import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext }
    
    init() {
        container = NSPersistentContainer(name: "TodoData")
        container.loadPersistentStores { (storeDescription, error)in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
    
    // ✅ Core Data에서 할 일 목록 가져오기 (ViewModel에서 호출)
    func fetchTodoItems() -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == false") // 완료되지않은 업무
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch {
            print("❌ Failed to fetch todo items: \(error.localizedDescription)")
            return []
        }
    }
    
    // ✅ 완료된 업무 목록 불러오기
    func completedFetchRequest() -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == true") // 완료된 업무
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch {
            print("❌ Failed to fetch todo items: \(error.localizedDescription)")
            return []
        }
    }
    
    // ✅ 새로운 TodoItem 추가
    func addItem(title: String, date: Date) {
        let todoItem = TodoItem(context: viewContext)
        todoItem.id = UUID()
        todoItem.title = title
        todoItem.date = date
        todoItem.isCompleted = false
        
        saveContext()
    }
    
    // ✅ 특정 TodoItem 삭제
    func deleteItem(item: TodoItem) {
        viewContext.delete(item)
        saveContext()
    }
    
    // ✅ 여러 개의 TodoItem 삭제
    func deleteItems(offsets: IndexSet, from items: FetchedResults<TodoItem>) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    // ✅ Todo 완료 상태 토글
    func toggleCompletion(task: TodoItem) {
        task.isCompleted.toggle()
        saveContext()
        }
    
    // ✅ 데이터 저장
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
