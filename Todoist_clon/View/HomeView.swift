//
//  ContentView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/15/25.
//

import SwiftUI

struct HomeView: View {
    @State private var todoList = [ListModel]()
    @State private var showSheet = false
    @State private var newTask = ""
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // 버튼 액션
                    print("버튼 클릭됨")
                }) {
                    Image(systemName: "ellipsis") // 기본 아이콘으로 점 3개
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 30, height: 20)
                        
                }
                .padding(.horizontal)
            }
            VStack {
                HStack {
                    Text("오늘")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text(getToday())
                        .padding(.horizontal)
                    Spacer()
                    
                }
            }
            VStack{
                //업무 리스트
                List {
                    ForEach(todoList.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: todoList[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todoList[index].isCompleted ? .green : .gray)
                                .onTapGesture {
                                    todoList[index].isCompleted.toggle()
                                }
                            Text(todoList[index].title ?? "아직 일정이 없어요~")
                                .strikethrough(todoList[index].isCompleted, color: .gray)
                        }
                        .padding(5)
                    }
                }
                HStack {
                    // 왼쪽 도움말 버튼
                    Button(action: {
                        // 버튼 액션
                        print("버튼 클릭됨")
                    }) {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 25)
                            
                    }
                    .padding(.horizontal)
                    //간격
                    Spacer()
                    // 오른쪽 업무 추가 버튼
                    Button(action: {
                        // 버튼 액션
                        showSheet = true
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(/*@START_MENU_TOKEN@*/Color(hue: 1.0, saturation: 0.518, brightness: 0.981)/*@END_MENU_TOKEN@*/)
                            .frame(width: 45, height: 45)
                            
                    }
                    .sheet(isPresented: $showSheet){
                        AddTaskView(showSheet: $showSheet, addTask: addTask)
                    }
                    .padding(.horizontal)
                }
            }
            HStack{
                VStack {
                    Button(action: {
                        // 버튼 액션
                        print("버튼 클릭됨")
                    }) {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        
                    }
                    Text("오늘")
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                Spacer()
                VStack {
                    Button(action: {
                        // 버튼 액션
                        print("버튼 클릭됨")
                    }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        
                    }
                    Text("다음")
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                Spacer()
                VStack {
                    Button(action: {
                        // 버튼 액션
                        print("버튼 클릭됨")
                    }) {
                        Image(systemName: "magnifyingglass") // 기본 아이콘으로 점 3개
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        
                    }
                    Text("검색")
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                Spacer()
                VStack {
                    Button(action: {
                        // 버튼 액션
                        print("버튼 클릭됨")
                    }) {
                        Image(systemName: "list.bullet") // 기본 아이콘으로 점 3개
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        
                    }
                    Text("목록")
                        .fontWeight(.bold)
                }
                
                .padding(.horizontal)
            }
            Spacer()
        }
    }
    
    //MARK: - get to Today
    func getToday() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 eeee"
        let today = Date()
        return formatter.string(from: today)
    }
    
    //MARK: - Add Task
    func addTask(_ task: String){
        todoList.append(ListModel(title: task))
    }
}

#Preview {
    HomeView()
}
