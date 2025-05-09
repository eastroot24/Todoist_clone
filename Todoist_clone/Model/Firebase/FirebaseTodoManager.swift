//
//  FirebaseTodoManager.swift
//  Todoist_clone
//
//  Created by eastroot on 4/2/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class FirebaseTodoManager {
    static let shared = FirebaseTodoManager() // Singleton 인스턴스
    private var db = Firestore.firestore()
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private init() {
        guard FirebaseApp.app() != nil else {
            fatalError("❌ Firebase가 아직 초기화되지 않았습니다.")
        }
        db = Firestore.firestore()
        print("✅ Firestore 인스턴스 생성 완료")
    }
    
    // ✅ 날짜별 문서 아래에 Todo 저장
    func addTodoToFirebase(todo: TodoItem) {
        guard let userId = userId else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todoDate = todo.date ?? Date() // 기본값 현재 날짜
        let formattedDate = dateFormatter.string(from: todoDate) // "2024-04-02" 형식
        
        let todoId = todo.id?.uuidString ?? UUID().uuidString
        
        let todoData: [String: Any] = [
            "id": todoId,
            "title": todo.title ?? "",
            "content": todo.content ?? "",
            "date": Timestamp(date: todoDate),
            "isCompleted": todo.isCompleted
        ]
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(formattedDate)  // 날짜 문서
            .collection("tasks")      // 해당 날짜 안의 할 일들
            .document(todoId)
            .setData(todoData) { error in
                if let error = error {
                    print("❌ Error saving to Firebase: \(error.localizedDescription)")
                } else {
                    print("✅ Todo saved under date: \(formattedDate)")
                }
            }
    }
    
    func syncCoreDataWithFirebase(localTodos: [TodoItem]) {
        guard let userId = userId else { return }
        
        let todosCollection = db.collection("users").document(userId).collection("todos")
        
        // ✅ 모든 날짜의 할 일들을 가져옴
        todosCollection.getDocuments { snapshot, error in
            guard let dateDocuments = snapshot?.documents, error == nil else {
                print("❌ Error fetching Firebase todos: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var firebaseTodoIDs: Set<String> = []
            
            let dispatchGroup = DispatchGroup()
            
            for dateDoc in dateDocuments {
                let date = dateDoc.documentID // 예: "2024-04-02"
                let tasksCollection = todosCollection.document(date).collection("tasks")
                
                dispatchGroup.enter() // ✅ 비동기 작업 시작
                tasksCollection.getDocuments { taskSnapshot, error in
                    guard let taskDocuments = taskSnapshot?.documents, error == nil else {
                        print("❌ Error fetching tasks for \(date): \(error?.localizedDescription ?? "Unknown error")")
                        dispatchGroup.leave()
                        return
                    }
                    
                    for taskDoc in taskDocuments {
                        firebaseTodoIDs.insert(taskDoc.documentID)
                    }
                    
                    dispatchGroup.leave() // ✅ 비동기 작업 종료
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // ✅ Firebase에 없는 로컬 Todo 추가
                for localTodo in localTodos {
                    if let localID = localTodo.id?.uuidString, !firebaseTodoIDs.contains(localID) {
                        self.addTodoToFirebase(todo: localTodo)
                    }
                }
                print("✅ CoreData와 Firebase 동기화 완료!")
            }
        }
    }


    // ✅ 날짜별 Todo 삭제
    func deleteTodoFromFirebase(todo: TodoItem) {
        guard let userId = userId, let todoId = todo.id?.uuidString, let todoDate = todo.date else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: todoDate)
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(formattedDate)
            .collection("tasks")
            .document(todoId)
            .delete { error in
                if let error = error {
                    print("❌ Error deleting from Firebase: \(error.localizedDescription)")
                } else {
                    print("✅ Todo deleted from Firebase under \(formattedDate)")
                }
            }
    }
    
    // ✅ 날짜별 Todo 업데이트 (완료 상태 변경)
    func updateTodoInFirebase(todo: TodoItem) {
        guard let userId = userId, let todoId = todo.id?.uuidString, let todoDate = todo.date else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: todoDate)
        
        let updatedData: [String: Any] = [
            "isCompleted": todo.isCompleted
        ]
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(formattedDate)
            .collection("tasks")
            .document(todoId)
            .updateData(updatedData) { error in
                if let error = error {
                    print("❌ Error updating Firebase: \(error.localizedDescription)")
                } else {
                    print("✅ Todo updated under \(formattedDate)")
                }
            }
    }
}

