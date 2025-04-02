//
//  DiaryEditorView.swift
//  Todoist_clone
//
//  Created by eastroot on 3/31/25.
//

import SwiftUI

struct DiaryEditorView: View {
    @Binding var entry: String
    var onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextEditor(text: $entry)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ 화면 전체 확장
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .navigationTitle("일기 작성")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("완료") {
//                            onSave() // ✅ 저장 기능
//                            dismiss() // ✅ 창 닫기
//                        }
//                    }
//                }
        }
        .navigationBarTitleDisplayMode(.inline) // ✅ 제목을 상단 중앙 정렬
        .onDisappear {
            onSave() // ✅ 저장 기능
            dismiss() // ✅ 창 닫기
        }
    }
}

