//
//  FirebaseManager.swift
//  Todoist_clone
//
//  Created by eastroot on 3/27/25.
//
import FirebaseCore

class FirebaseManager {
    static let shared = FirebaseManager()
    
    init() {
        FirebaseApp.configure()
    }
}
