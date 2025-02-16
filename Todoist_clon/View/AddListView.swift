//
//  AddListView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//
import SwiftUI

struct AddTaskView: View {
    @Binding var showSheet: Bool
    @State var newTask: String = ""
    var addTask: (String) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("할 일을 입력하세요", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("저장") {
                    addTask(newTask)
                    showSheet = false // 입력 후 창 닫기
                    newTask = "" // 입력값 초기화
                }
                .padding()
                .background(Color(hue: 1.0, saturation: 0.518, brightness: 0.981))
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle("새로운 일정 추가")
            .navigationBarItems(trailing: Button("닫기") {
                showSheet = false
            })
        }
    }
}
