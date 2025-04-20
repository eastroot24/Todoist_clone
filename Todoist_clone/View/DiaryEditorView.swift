//
//  DiaryEditorView.swift
//  Todoist_clone
//
//  Created by eastroot on 3/31/25.
//

import SwiftUI

struct DiaryEditorView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @Binding var mood: String
    @Binding var entry: String
    @State private var isSelectingMood = false // 기분 선택 토글
    var onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            HStack{
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
            TextEditor(text: $entry)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ 화면 전체 확장
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .navigationTitle("일기 작성")
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline) // ✅ 제목을 상단 중앙 정렬
        .onDisappear {
            onSave() // ✅ 저장 기능
            dismiss() // ✅ 창 닫기
        }
    }
    // 오늘 날짜 가져오기
    func getTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일 EEEE"
        return formatter.string(from: Date())
    }
    // 저장용 날짜 가져오기
    func savingGetTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

