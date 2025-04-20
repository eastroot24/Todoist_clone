//
//  MonthCalendarViewModel.swift
//  Todoist_clone
//
//  Created by eastroot on 4/20/25.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
class MonthCalendarViewModel: ObservableObject {
    @Published var previewItems: [CalendarPreviewData] = []

    private let provider: CalendarDataProvider

    init(context: NSManagedObjectContext) {
        self.provider = CalendarDataProvider(context: context)
    }

    func load(for date: Date) async {
        let previews = await provider.fetchCalendarPreview(forMonth: date)
        self.previewItems = previews
    }

    func preview(for date: Date) -> CalendarPreviewData? {
        let day = Calendar.current.startOfDay(for: date)
        return previewItems.first { Calendar.current.isDate($0.date, inSameDayAs: day) }
    }
}

