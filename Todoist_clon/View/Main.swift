//
//  Main.swift
//  Todoist_clon
//
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
                HomeView(todoListViewModel: todoListViewModel)
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

//추가 창의 상태 여부를 전역적으로 관리하기 위한 
class ShowSheetManager: ObservableObject {
    @Published var showSheet = false
}


//#Preview {
//    Main(todoListViewModel: .init(context: .init()))
//}
