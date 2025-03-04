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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    // 로그인 및 사용자 등록에만은 필요 없는 코드
    // 인증이 끝나고 앱이 받는 url을 처리
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            // Handle other custom URL types.
            return true
        }
        
        
        // If not handled by this app, return false.
        return false
    }
}

@main
struct Todoist_clonApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var todoListViewModel = TodoListViewModel(context: PersistenceController.shared.container.viewContext)
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Main(todoListViewModel: todoListViewModel)
        }
    }
}
