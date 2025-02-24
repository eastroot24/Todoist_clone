import SwiftUI

struct ManageBoxView: View {
    @ObservedObject var todoList: TodoListModel
    @Environment(\.dismiss) var dismiss // 🔙 화면 닫기
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("완료되지 않은 업무")) {
                    let incompleteTasks = todoList.lists.filter { !$0.isCompleted }
                    
                    if incompleteTasks.isEmpty {
                        Text("완료되지 않은 업무가 없습니다.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(incompleteTasks) { task in
                            todoItemRow(for: task)
                        }
                    }
                }
            }
            .navigationTitle("관리함")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss() // 🔙 화면 닫기
                    }
                }
            }
        }
    }

    // 📝 개별 일정 항목 UI
    private func todoItemRow(for task: ListModel) -> some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    if let index = todoList.lists.firstIndex(where: { $0.id == task.id }) {
                        todoList.lists[index].isCompleted.toggle()
                    }
                }
            
            Text(task.title ?? "No Title")
                .strikethrough(task.isCompleted, color: .gray)
        }
    }
}
