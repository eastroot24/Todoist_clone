//
//  TimeLineBackground.swift
//  Todoist_clone
//
//  Created by eastroot on 5/9/25.
//

import SwiftUI

struct TimeLineBackground: View {
    let hourHeight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { hour in
                HStack(alignment: .top) {
                    Text(String(format: "%02d:00", hour))
                        .font(.caption)
                        .frame(width: 50, alignment: .trailing)

                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.leading, 8)
                }
                .frame(height: hourHeight)
            }
        }
        .padding(.leading, 8)
    }
}
