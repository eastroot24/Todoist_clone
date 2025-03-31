//
//  DiaryViewModel.swift
//  Todoist_clone
//
//  Created by eastroot on 3/31/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DiaryViewModel: ObservableObject {
    @Published var diaryEntry: DiaryEntry? // 현재 일기 데이터
    
    private var db = Firestore.firestore()
    
    func fetchDiary(completion: @escaping (String, String) -> Void) {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let today = getFormattedDate()
            
            db.collection("diaries").document(userId).collection("entries").document(today).getDocument { snapshot, error in
                if let data = snapshot?.data(), error == nil {
                    let savedMood = data["mood"] as? String ?? "😀"
                    let savedEntry = data["content"] as? String ?? ""
                    DispatchQueue.main.async {
                        completion(savedEntry, savedMood)
                    }
                }
            }
        }
    
    func saveDiary(mood: String, entry: String) {
           guard let userId = Auth.auth().currentUser?.uid else { return }
           let today = getFormattedDate()
           
           let diaryData: [String: Any] = [
               "date": today,
               "mood": mood,
               "content": entry
           ]
           
        db.collection("diaries").document(userId).collection("entries").document(today).setData(diaryData) { error in
               if let error = error {
                   print("Error saving diary: \(error.localizedDescription)")
               } else {
                   print("Diary saved successfully!")
               }
           }
       }
    
    private func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

struct DiaryEntry: Identifiable {
    var id: String { date }
    let date: String
    let mood: String
    let content: String
}

