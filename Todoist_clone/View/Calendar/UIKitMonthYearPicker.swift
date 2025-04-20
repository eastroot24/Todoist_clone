//
//  UIKitMonthYearPicker.swift
//  Todoist_clone
//
//  Created by eastroot on 4/20/25.
//

import SwiftUI

struct UIKitMonthYearPicker: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.calendar = Calendar(identifier: .gregorian)
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selectedDate
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate)
    }

    class Coordinator: NSObject {
        var selectedDate: Binding<Date>

        init(selectedDate: Binding<Date>) {
            self.selectedDate = selectedDate
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            selectedDate.wrappedValue = sender.date
        }
    }
}

