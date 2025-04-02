//
//  UserPreference.swift
//  Todoist_clone
//
//  Created by eastroot on 3/31/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserPreference: ObservableObject {
    @Published var startHour: Int = 9
    @Published var endHour: Int = 18
    private var db = Firestore.firestore()
    private let userID = Auth.auth().currentUser?.uid
    
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        // userID가 nil인지 확인
        guard let userID = userID else {
            print("User ID is nil, cannot load settings.")
            return
        }
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let data = snapshot?.data(), error == nil {
                DispatchQueue.main.async {
                    self.startHour = data["startHour"] as? Int ?? 9
                    self.endHour = data["endHour"] as? Int ?? 18
                }
            }
        }
    }
    
    func saveSettings() {
        //userID가 nil인지 확인 
        guard let userID = userID else {
            print("User ID is nil, cannot save settings.")
            return
        }
        db.collection("users").document(userID).setData([
            "startHour": startHour,
            "endHour": endHour
        ], merge: true)
    }
}


