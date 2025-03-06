//
//  ManageView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

struct ManageView: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    var body: some View {
        NavigationStack {
            VStack {
                // ✅ 상단 바 (계정, 알림, 설정 버튼)
                HStack {
                    //계정관리뷰
                    NavigationLink(destination: AccountView(todoListViewModel: todoListViewModel)){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    //알림설정뷰
                    NavigationLink(destination: AlertView()){
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.orange)
                    }
                    //설정뷰
                    NavigationLink(destination: OptionsView()){
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                }
                
                .padding(.horizontal)
                
                NavigationLink(destination: ManageBoxView(todoListViewModel: todoListViewModel)){
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
        }
        .overlay(
            VStack{
                Spacer()
                //AddTaskButton - 일정 추가 버튼
                AddTaskButton(todoListViewModel: todoListViewModel)
                    .padding(.vertical, 20)
            }
        )
    }
}


#Preview {
    //ManageView(todoList: .init())
}
