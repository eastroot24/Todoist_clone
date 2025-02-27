//
//  Main.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct Main: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    @State private var showHomeSheet = false
    @State private var showNextSheet = false
    @State private var showSearchSheet = false
    @State private var showManageSheet = false
    var body: some View {
        VStack {
            FirstHeader()
            TabView {
                //홈화면
                HomeView(todoListViewModel: todoListViewModel, showSheet: $showHomeSheet)
                    .tabItem {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("오늘")
                    }
                //다음화면
                NextView(todoListViewModel: todoListViewModel, showSheet: $showNextSheet)
                    .tabItem {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("다음")
                            .fontWeight(.bold)
                    }
                SearchView(todoListViewModel: todoListViewModel, showSheet: $showSearchSheet)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 35)
                        Text("검색")
                            .fontWeight(.bold)
                    }
                ManageView(todoListViewModel: todoListViewModel, showSheet: $showManageSheet)
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

#Preview {
    //Main(todoListViewModel: .init(context: .init()))
}
