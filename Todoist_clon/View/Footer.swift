//
//  Footer.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct Footer: View {
    var body: some View {
        TabView {
            //홈화면
            HomeView()
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

#Preview {
    Footer()
}
