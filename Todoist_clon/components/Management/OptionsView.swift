//
//  OptionsView.swift
//  Todoist_clon
//
//  Created by eastroot on 3/6/25.
//

import SwiftUI

struct OptionsView: View {
    @Environment(\.dismiss) var dismiss // 🔙 화면 닫기s
    
    var body: some View {
        VStack {
            Text("OptionsView")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
                dismiss()
            }){
                HStack {
                    Image(systemName: "chevron.left")
                    Text("뒤로")
                }
            })
    }
}

#Preview {
    OptionsView()
}
