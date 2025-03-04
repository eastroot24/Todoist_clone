//
//  ProfileView.swift
//  Todoist_clon
//
//  Created by eastroot on 3/4/25.
//

import SwiftUI
import FirebaseAuth
struct ProfileView: View {
    var user: User?
    @Environment(\.dismiss) var dismiss // 화면을 닫기 위한 dismiss 환경 변수
    var body: some View {
        NavigationView {
            VStack{
                // ✅ 프로필 사진 + 닉네임 표시
                HStack {
                    if let photoURL = user?.photoURL, let url = URL(string: photoURL.absoluteString) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text(user?.displayName ?? "닉네임 없음")
                            .font(.headline)
                        Text(user?.email ?? "이메일 없음")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        DispatchQueue.main.async {
                            signOut()
                            dismiss()
                        }
                    }) {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(Color.red)
                }
                .padding()
                
                
                
                
                // ✅ 완료한 업무 수 표시
                Text("완료한 업무: \(getCompletedTaskCount())개")
                    .font(.title2)
                    .padding()
                
                // ✅ 탭으로 일일/주간별 업무 진행 상황 관리
                TabView {
                    DailyProgressView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("일일 진행")
                        }
                    
                    WeeklyProgressView()
                        .tabItem {
                            Image(systemName: "clock")
                            Text("주간 진행")
                        }
                }
            }
        }
    }
    
    
    // ✅ 완료한 업무 개수 가져오기
    func getCompletedTaskCount() -> Int {
        // CoreData에서 완료된 업무 개수 가져오는 코드 필요
        return 0
    }
    
    //로그아웃 기능
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

#Preview {
    ProfileView()
}
