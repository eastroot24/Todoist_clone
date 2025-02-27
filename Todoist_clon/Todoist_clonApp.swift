//
//  Todoist_clonApp.swift
//  Todoist_clon
//
//  Created by eastroot on 2/15/25.
//

import SwiftUI

@main
struct Todoist_clonApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var todoListViewModel = TodoListViewModel(context: PersistenceController.shared.container.viewContext)
    var body: some Scene {
        WindowGroup {
            Main(todoListViewModel: todoListViewModel)        }
    }
}
