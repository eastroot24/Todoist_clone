//
//  Main.swift
//  Todoist_clone
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct Main: View {
    //할일 목록 객체
    @ObservedObject var todoListViewModel: TodoListViewModel
    
    var body: some View {
        VStack {
            FirstHeader()
            TabView {
                //홈화면
                HomeView()
                    .tabItem {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("오늘")
                    }
                //다음화면
                NextView(todoListViewModel: todoListViewModel)
                    .tabItem {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("다음")
                            .fontWeight(.bold)
                    }
                //검색화면
                SearchView(todoListViewModel: todoListViewModel)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 35)
                        Text("검색")
                            .fontWeight(.bold)
                    }
                //관리화면
                ManageView(todoListViewModel: todoListViewModel)
                    .tabItem {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("목록")
                            .fontWeight(.bold)
                    }
            }
            .accentColor(Color.red)
            
        }
    }
}



//#Preview {
//    Main(todoListViewModel: .init(context: .init()))
//}
