//
//  ListModel.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import Foundation

//리스트 형식
struct ListModel: Identifiable {
    var id = UUID()
    var title: String?
    var isCompleted = false
}
