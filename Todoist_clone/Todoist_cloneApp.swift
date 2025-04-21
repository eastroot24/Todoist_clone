//
//  Todoist_clonApp.swift
//  Todoist_clon
//
//  Created by eastroot on 2/15/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
        }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct Todoist_clonApp: App {
    
    let persistenceController = PersistenceController.shared
    @StateObject var todoListViewModel = TodoListViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject var userService = UserService()
    @StateObject var userPreference = UserPreference()
    @StateObject var diaryViewModel = DiaryViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Main(todoListViewModel: todoListViewModel)
                .environmentObject(userService)
                .environmentObject(todoListViewModel)
                .environmentObject(userPreference)
                .environmentObject(diaryViewModel)
        }
        
    }
}
