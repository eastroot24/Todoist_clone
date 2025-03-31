//
//  Consumer.swift
//  Todoist_clone
//
//  Created by eastroot on 3/27/25.
//

import Foundation

struct Consumer: Identifiable {
    let id: String
    let name: String
    let email: String
    let joinDate: Date
    var taskCount: Int
    var rank: String
}
