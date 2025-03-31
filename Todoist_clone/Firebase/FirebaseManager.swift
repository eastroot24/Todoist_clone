//
//  FirebaseManager.swift
//  Todoist_clone
//
//  Created by eastroot on 3/27/25.
//
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    init() {
        FirebaseApp.configure()
    }
}
