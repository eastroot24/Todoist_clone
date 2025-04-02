//
//  TimeSettingView.swift
//  Todoist_clone
//
//  Created by eastroot on 3/31/25.
//
import SwiftUI

struct TimeSettingView: View {
    @EnvironmentObject var userPreference: UserPreference
    @EnvironmentObject var userService: UserService 
    @Environment(\.dismiss) var dismiss // 화면 닫기 기능
    @State private var tempStartHour: Int
    @State private var tempEndHour: Int

    init(userPreference: UserPreference) {
        _tempStartHour = State(initialValue: userPreference.startHour)
        _tempEndHour = State(initialValue: userPreference.endHour)
    }

    var body: some View {
        Form {
            Section(header: Text("업무 시간 설정")) {
                HStack {
                    Text("시작 시간:")
                    Spacer()
                    Picker("", selection: $tempStartHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text("\(hour):00").tag(hour)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                HStack {
                    Text("종료 시간:")
                    Spacer()
                    Picker("", selection: $tempEndHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text("\(hour):00").tag(hour)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            // 저장 버튼 추가
            Button("저장") {
                userPreference.startHour = tempStartHour
                userPreference.endHour = tempEndHour
                userPreference.saveSettings()
                dismiss() // 화면 닫기
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("시간 설정")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            userPreference.startHour = tempStartHour
            userPreference.endHour = tempEndHour
            userPreference.saveSettings() // ✅ Firestore에 저장
            print(userPreference.endHour)
            dismiss() // 화면 닫기
        }){
            HStack {
                Image(systemName: "chevron.left")
                Text("뒤로")
            }
        }
        )
    }
}
