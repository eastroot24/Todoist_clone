//
//  Persistence.swift
//  Todoist_clone
//
//  Created by eastroot on 2/25/25.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseFirestore

struct PersistenceController {
    static let shared = PersistenceController()
    
    // ✅ Firebase 저장을 위한 매니저 인스턴스
    // 🔥 Firebase 싱글턴을 늦게 초기화하도록 변경
        lazy var firebaseManager: FirebaseTodoManager = {
            print("✅ FirebaseTodoManager 초기화됨")
            return FirebaseTodoManager.shared
        }()
    lazy var userService: UserService = {
        print("✅ UserService 초기화됨")
        return UserService.shared
    }()
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
    
    // ✅ Core Data에서 할 일 목록 가져오기 (Firebase와 동기화)
    mutating func fetchTodoItems() -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        //request.predicate = NSPredicate(format: "isCompleted == false")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let items = try viewContext.fetch(request)
            
            // 🔥 Firebase에 저장되지 않은 항목만 동기화
            firebaseManager.syncCoreDataWithFirebase(localTodos: items)
            
            return items
        } catch {
            print("❌ Failed to fetch todo items: \(error.localizedDescription)")
            return []
        }
    }
    
    // ✅ 완료된 업무 목록 불러오기
    mutating func completedFetchRequest() -> [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "isCompleted == true")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let items = try viewContext.fetch(request)
            // 🔥 Firebase에 저장되지 않은 완료 항목만 동기화
            firebaseManager.syncCoreDataWithFirebase(localTodos: items)
            return items
        } catch {
            print("❌ Failed to fetch completed todo items: \(error.localizedDescription)")
            return []
        }
    }
    
    // ✅ 새로운 TodoItem 추가 (Core Data + Firebase 저장)
    mutating func addItem(title: String, date: Date, content: String) {
        let todoItem = TodoItem(context: viewContext)
        todoItem.id = UUID()
        todoItem.title = title
        todoItem.content = content
        todoItem.date = date
        todoItem.isCompleted = false
        todoItem.content = content
        saveContext()
        
        // 🔥 Firebase에도 바로 저장
        firebaseManager.addTodoToFirebase(todo: todoItem)
    }
    
    // ✅ 특정 TodoItem 삭제 (Core Data + Firebase 동시 삭제)
    mutating func deleteItem(item: TodoItem) {
        firebaseManager.deleteTodoFromFirebase(todo: item)
        viewContext.delete(item)
        saveContext()
    }
    
    // ✅ 여러 개의 TodoItem 삭제 (Core Data + Firebase 동시 삭제)
    mutating func deleteItems(offsets: IndexSet, from items: FetchedResults<TodoItem>) {
        offsets.map { items[$0] }.forEach { todo in
            firebaseManager.deleteTodoFromFirebase(todo: todo)
            viewContext.delete(todo)
        }
        saveContext()
    }
    
    // ✅ Todo 완료 상태 토글 (Core Data + Firebase 업데이트)
    mutating func toggleCompletion(task: TodoItem) {
        task.isCompleted.toggle()
        saveContext()
        firebaseManager.updateTodoInFirebase(todo: task)
        
        let count = completedFetchRequest().count
        userService.updateTaskCount(count)
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

