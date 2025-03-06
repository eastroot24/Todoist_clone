//
//  AddListView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @State var newTask: String = ""
    @State var newDate: Date = Date()
    var addTask: (String, Date) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("할 일을 입력하세요", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                VStack{
                    DatePicker("날짜 선택", selection: $newDate, displayedComponents: .date)
                                   .datePickerStyle(.wheel) // 휠 스타일 적용
                                   .environment(\.locale, Locale(identifier: "ko_KR"))
                    Button("저장") {
                        addTask(newTask, newDate)
                        dismiss() // 입력 후 창 닫기
                        newTask = "" // 입력값 초기화
                    }
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.518, brightness: 0.981))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .scaledToFit()
            .navigationTitle("새로운 일정 추가")
            .navigationBarItems(trailing: Button("닫기") {
                dismiss()
            })
                .foregroundStyle(Color.red)
                .fontWeight(.bold)
                .padding()
            Spacer()
            
        }
    }
}
