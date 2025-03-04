//
//  ManageDetailView.swift
//  Todoist_clon
//
//  Created by eastroot on 3/4/25.
//
import SwiftUI
struct DailyProgressView: View {
    var body: some View {
        VStack {
            Text("일일 업무 진행 현황")
                .font(.title2)
            // ✅ 여기에 일일 업무 진행률을 표시하는 UI 추가
        }
        .padding()
    }
}

struct WeeklyProgressView: View {
    var body: some View {
        VStack {
            Text("주간 업무 진행 현황")
                .font(.title2)
            // ✅ 여기에 주간 업무 진행률을 표시하는 UI 추가
        }
        .padding()
    }
}
