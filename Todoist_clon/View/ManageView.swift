//
//  ManageView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct ManageView: View {
    @ObservedObject var todoList: TodoListModel
    @Binding var showSheet: Bool
    @State private var showMangeBox = false // 관리함 표시여부
    var body: some View {
        NavigationView {
            VStack {
                // ✅ 상단 바 (계정, 알림, 설정 버튼)
                HStack {
                    Button(action: {
                        // 계정 아이콘 액션
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }

                    Spacer()
                    
                    Button(action: {
                        // 알림 설정 액션
                    }) {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.orange)
                    }

                    Button(action: {
                        // 설정 버튼 액션
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    showMangeBox = true // 🔥 화면 전환
                                }) {
                                    HStack {
                                        Image(systemName: "tray.fill") // 📦 관리함 아이콘
                                            .foregroundStyle(Color.red)
                                        Text("관리함")
                                            .font(.headline)
                                            .foregroundStyle(Color.red)
                                        Spacer()
                                        Image(systemName: "chevron.right") // ➡️ 이동 아이콘
                                            .foregroundStyle(Color.red)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                                .padding()
                Spacer()
            }
            .overlay(
                VStack{
                    Spacer()
                    //AddTaskButton - 일정 추가 버튼
                    AddTaskButton(todoList: todoList, showSheet: $showSheet)
                        .padding(.vertical, 20)
                }
            )
            .sheet(isPresented: $showMangeBox) {
                ManageBoxView(todoList: todoList)
            }
        }
    }
}

#Preview {
    ManageView(todoList: .init(), showSheet: .constant(false))
}
