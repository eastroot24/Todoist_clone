//
//  DiaryView.swift
//  Todoist_clone
//
//  Created by eastroot on 3/31/25.
//

import SwiftUI

struct DiaryView: View {
    @EnvironmentObject var todoListViewModel: TodoListViewModel
    @ObservedObject var diaryViewModel = DiaryViewModel()
    @State private var mood: String = "😄"
    @State private var entry: String = ""
    @State private var isSelectingMood = false // 기분 선택 토글
    @State private var isEditing = false // ✅ 수정 여부를 감지하는 변수 추가

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // 오늘 날짜 + 기분 선택
                HStack {
                    Text(getTodayDate())
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    // 기분 선택 버튼
                    Button(action: { isSelectingMood.toggle() }) {
                        HStack {
                            Text("기분:")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text(mood) // 선택된 이모지
                                .font(.title)
                            Image(systemName: "chevron.down") // 아래 꺾쇠
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                if isSelectingMood {
                    HStack {
                        ForEach(["😀", "😐", "😢", "😡", "🥰"], id: \.self) { emoji in
                            Button(action: {
                                mood = emoji
                                diaryViewModel.saveDiary(for: savingGetTodayDate(), mood: mood, entry: entry)
                                isSelectingMood = false // 메뉴 닫기
                            }) {
                                Text(emoji)
                                    .font(.largeTitle)
                                    .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // ✅ **일기 수정 가능하게 변경**
                Button(action: {
                    isEditing = true // ✅ 수정 모드 활성화
                }) {
                    VStack(alignment: .leading) {
                        if entry.isEmpty {
                            Text("일기를 작성해 보세요.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            Text(entry)
                                .foregroundColor(.primary)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity) // ✅ 전체 너비 확장
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .sheet(isPresented: $isEditing) {
                    DiaryEditorView(mood: $mood, entry: $entry, onSave: {
                        diaryViewModel.saveDiary(for: savingGetTodayDate(), mood: mood, entry: entry) // ✅ 저장 기능 실행
                    })
                }

                Spacer()
            }
            .padding(.top)
            .onAppear {
                diaryViewModel.fetchDiary(for: savingGetTodayDate()) { savedEntry, savedMood in
                    self.entry = savedEntry
                    self.mood = savedMood
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
    
    // 오늘 날짜 가져오기
    func getTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 EEEE"
        return formatter.string(from: Date())
    }
    // 저장용 오늘 날짜 가져오기
    func savingGetTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
