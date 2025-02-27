//
//  Footer.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct AddTaskButton: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    
    @Binding var showSheet: Bool
    var body: some View {
        HStack {
            //간격
            Spacer()
            // 오른쪽 업무 추가 버튼
            Button(action: {
                if !showSheet {
                    showSheet = true
                }
                
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.518, brightness: 0.981))
                    .frame(width: 45, height: 45)
                
            }
            .sheet(isPresented: $showSheet){
                AddTaskView(showSheet: $showSheet, addTask: addTask)
            }
            .padding(.horizontal)
        }
    }
    //MARK: - Add Task
    func addTask    (task: String, date: Date){
        todoListViewModel.addItem(title: task, date: date)
    }

}
