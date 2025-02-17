//
//  Header.swift
//  Todoist_clon
//
//  Created by eastroot on 2/16/25.
//

import SwiftUI

struct FirstHeader: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // 버튼 액션
                print("버튼 클릭됨")
            }) {
                Image(systemName: "ellipsis") // 기본 아이콘으로 점 3개
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.black)
                    .frame(width: 30, height: 20)
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    FirstHeader()
}
