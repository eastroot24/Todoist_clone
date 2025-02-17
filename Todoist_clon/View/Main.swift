//
//  Main.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct Main: View {
    @StateObject var todoList = TodoListModel()
    @State private var showSheet = false
    var body: some View {
        VStack {
            FirstHeader()
            TabView {
                //홈화면
                HomeView(todoList: todoList, showSheet: $showSheet)
                    .tabItem {
                        Image(systemName: "clock.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        Text("오늘")
                    }
                //다음화면
                NextView()
                    .tabItem {
                        Image(systemName: "calendar.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        Text("다음")
                            .fontWeight(.bold)
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 40, height: 35)
                        Text("검색")
                            .fontWeight(.bold)
                    }
                ManageView()
                    .tabItem {
                        Image(systemName: "list.bullet.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 30, height: 30)
                        Text("목록")
                            .fontWeight(.bold)
                    }
            }
            
        }
    }
}

#Preview {
    Main()
}
