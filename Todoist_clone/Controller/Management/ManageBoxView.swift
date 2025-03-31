import SwiftUI

struct ManageBoxView: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    @Environment(\.dismiss) var dismiss // 🔙 화면 닫기
    @State private var showDeleteConfirmation = false // 삭제 확인 Alert 표시 여부
    @State private var showDeleteOptions = false // 전체 삭제 탭 표시 여부
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Menu{
                    Button(action: {
                        // 버튼 클릭시 전체 삭제 탭이 나오고 탭을 누르면 한번 더 알러트 창으로 물어 본 후 삭제
                        self.showDeleteConfirmation = true
                    }) {
                        Label("전체 삭제", systemImage: "trash")
                            .foregroundStyle(Color.red)
                    }}
                label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 30, height: 20)
                }
                .padding(.horizontal)
            }
            List {
                Section(header: Text("완료되지 않은 업무")) {
                    let incompleteTasks = todoListViewModel.todoItems.filter { !$0.isCompleted }
                    
                    if incompleteTasks.isEmpty {
                        Text("완료되지 않은 업무가 없습니다.")
                            .foregroundStyle(.gray)
                    } else {
                        ForEach(incompleteTasks) { task in
                            todoListViewModel.todoItemRow(for: task)
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.red)
                Section(header: Text("완료된 업무")) {
                    let completeTasks = todoListViewModel.completedItems.filter { $0.isCompleted }
                    
                    if completeTasks.isEmpty {
                        Text("완료된 업무가 없습니다.")
                            .foregroundStyle(.gray)
                    } else {
                        ForEach(completeTasks) { task in
                            todoListViewModel.todoItemRow(for: task)
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.red)
            }
            .navigationTitle("관리함")
            
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("모든 업무를 삭제하시겠습니까?"),
                message: Text("이 작업은 되돌릴 수 없습니다."),
                primaryButton: .destructive(Text("삭제")) {
                    todoListViewModel.deleteAllTasks() // 전체 삭제
                },
                secondaryButton: .cancel()
            )
        }
        .overlay(
            VStack{
                Spacer()
                //AddTaskButton - 일정 추가 버튼
                AddTaskButton(todoListViewModel: todoListViewModel)
                    .padding(.vertical, 20)
            }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }){
            HStack {
                Image(systemName: "chevron.left")
                Text("뒤로")
            }
        }
        )
        
    }
}
