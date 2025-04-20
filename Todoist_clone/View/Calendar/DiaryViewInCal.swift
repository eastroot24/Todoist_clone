//
//  DiaryView.swift
//  Todoist_clone
//
//  Created by eastroot on 4/17/25.
//

import SwiftUI

struct DiaryViewInCal: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    var selectedDate: Date
    @State private var mood: String = "😄"
    @State private var entry: String = ""
    @State private var isSelectingMood: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(formattedDate(selectedDate))
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
            if isSelectingMood {
                HStack {
                    ForEach(["😀", "😐", "😢", "😡", "🥰"], id: \.self) { emoji in
                        Button(action: {
                            mood = emoji
                            diaryViewModel.saveDiary(for: savingGetDate(selectedDate), mood: mood, entry: entry)
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
            TextEditor(text: $entry)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ 화면 전체 확장
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .navigationTitle("일기 작성")
        }
        .onDisappear {
            diaryViewModel.saveDiary(for: savingGetDate(selectedDate), mood: mood, entry: entry)
        }
        .padding(.horizontal)
        .onAppear {
            diaryViewModel.fetchDiary(for: savingGetDate(selectedDate)) { savedEntry, savedMood in
                self.entry = savedEntry
                self.mood = savedMood
            }
        }
        
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    // 저장용 날짜 가져오기
    func savingGetDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

