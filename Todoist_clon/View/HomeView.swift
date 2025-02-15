//
//  ContentView.swift
//  Todoist_clon
//
//  Created by eastroot on 2/15/25.
//

import SwiftUI

struct HomeView: View {
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
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Content")/*@END_MENU_TOKEN@*/
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
                        print("버튼 클릭됨")
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.blue)
                            .frame(width: 45, height: 45)
                            
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
    func getToday() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 eeee"
        let today = Date()
        return formatter.string(from: today)
    }
}

#Preview {
    HomeView()
}
