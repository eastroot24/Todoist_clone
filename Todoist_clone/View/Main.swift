//
//  Main.swift
//  Todoist_clone
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var userService: UserService
    // 할 일 목록 객체
    @ObservedObject var todoListViewModel: TodoListViewModel
    @EnvironmentObject var userPreference: UserPreference // 사용자 설정 객체
    @State private var currentHour = Main.getCurrentHour()
    @State private var selection: Int = 0
    
    init(todoListViewModel: TodoListViewModel) {
        self.todoListViewModel = todoListViewModel
    }
    
    var body: some View {
        VStack {
            FirstHeader()
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("오늘")
                    }
                    .tag(0)
                
                DiaryView()
                    .tabItem {
                        Image(systemName: "pencil.and.scribble")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("일기")
                            .fontWeight(.bold)
                    }
                    .tag(1)
                
                NextView(todoListViewModel: todoListViewModel)
                    .tabItem {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("다음")
                            .fontWeight(.bold)
                    }
                    .tag(2)
                
                SearchView(todoListViewModel: todoListViewModel)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 35)
                        Text("검색")
                            .fontWeight(.bold)
                    }
                    .tag(3)
                
                ManageView(todoListViewModel: todoListViewModel)
                    .tabItem {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("목록")
                            .fontWeight(.bold)
                    }
                    .tag(4)
            }
            .accentColor(Color.red)
        }
        .onAppear {
            selection = Main.getInitialTab(userPreference: userPreference)
        }
        .onChange(of: userPreference.startHour){
            updateTabSelection()
        }
        .onChange(of: userPreference.endHour) {
            updateTabSelection()
        }
    }
    
    // 지역에 따른 시간 불러오는 함수
    static func getCurrentHour() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.timeZone = TimeZone.current // 사용자의 로컬 타임존 적용
        let hourString = formatter.string(from: Date())
        return Int(hourString) ?? 0
    }
    
    // ✅ 초기 선택 탭을 결정하는 함수
    static func getInitialTab(userPreference: UserPreference) -> Int {
        let currentHour = getCurrentHour()
        let userStartHour = userPreference.startHour
        let userEndHour = userPreference.endHour
        print("지금 시각: \(currentHour), 시작 시각: \(userStartHour), 종료 시각: \(userEndHour)")
        let result = (currentHour >= userStartHour && currentHour < userEndHour) ? 0 : 1
        print(result)
        return result
    }
    // ✅ userPreference 값이 변경될 때 selection 업데이트
    private func updateTabSelection() {
        selection = Main.getInitialTab(userPreference: userPreference)
    }
}
