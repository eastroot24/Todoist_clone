//
//  TodoListViewModel.swift
//  Todoist_clon
//
//  Created by eastroot on 2/25/25.
//

import Foundation
import CoreData

class TodoListViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = [] // ✅ Core Data에서 불러온 데이터 저장
    
    private let persistenceController = PersistenceController.shared
    
    init(context: NSManagedObjectContext) {
        fetchTodoItems() // 초기 데이터 로드
    }
    
    // ✅ Core Data에서 TodoItem 불러오기
    func fetchTodoItems() {
        todoItems = persistenceController.fetchTodoItems()
    }
    
    // ✅ 새로운 TodoItem 추가
    func addItem(title: String, date: Date) {
        persistenceController.addItem(title: title, date: date)
        fetchTodoItems()
    }
    
    // ✅ 특정 TodoItem 삭제
    func deleteItem(item: TodoItem) {
        persistenceController.deleteItem(item: item)
        fetchTodoItems() // 데이터 새로고침
    }
}
