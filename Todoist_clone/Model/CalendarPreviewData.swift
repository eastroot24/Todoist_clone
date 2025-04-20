//
//  CalendarPreviewData.swift
//  Todoist_clone
//
//  Created by eastroot on 4/20/25.
//

import Foundation

struct CalendarPreviewData: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let todoPreview: String?
    let hasDiary: Bool
}
