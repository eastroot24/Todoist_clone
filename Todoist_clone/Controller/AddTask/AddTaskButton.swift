//
//  Footer.swift
//  Todoist_clone
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI
//케케~~~
struct AddTaskButton: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    @State private var showSheet = false // ✅ Sheet 상태 관리
    var body: some View {
        HStack {
            //간격
            Spacer()
            // 오른쪽 업무 추가 버튼
            Button(action: {
                showSheet = true
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.518, brightness: 0.981))
                    .frame(width: 45, height: 45)
                
            }
            .sheet(isPresented: $showSheet){
                AddTaskView(addTask: addTask)
            }
            .padding(.horizontal)
        }
    }
    //MARK: - Add Task
    func addTask    (task: String, date: Date){
        todoListViewModel.addItem(title: task, date: date)
    }

}
