//
//  ProfileView.swift
//  Todoist_clone
//  Created by eastroot on 3/4/25.
//

import SwiftUI
import FirebaseAuth
struct ProfileView: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    var user: User?
    @Environment(\.dismiss) var dismiss // 화면을 닫기 위한 dismiss 환경 변수
    @State var pickView: String = "일간" //선택한 뷰
    var views : [String] = ["일간", "주간"] //주간/일간 뷰 리스트
    @EnvironmentObject var userService: UserService

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
                
                //랭크 표시
                if let consumer = userService.currentUser {
                    VStack(alignment: .leading) {
                        Text("랭크: \(consumer.rank)")
                            .font(.title3.bold())
                        
                        let completedCount = consumer.taskCount
                        let progress = todoListViewModel.rankProgress(currentRank: consumer.rank, currentCount: completedCount)
                        let info = todoListViewModel.rankProgressInfo(currentRank: consumer.rank, currentCount: completedCount)

                        VStack(alignment: .leading) {
                            ProgressView(value: progress)
                                .tint(.blue)
                                .frame(height: 10)
                            
                            HStack {
                                Spacer()
                                if let nextRank = info.nextRank, let remaining = info.remaining, nextRank != "최고 랭크" {
                                    Text("→ \(nextRank)까지 \(remaining)개 남음")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("최고 랭크 달성!")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Text("완료한 업무: \(consumer.taskCount)개")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                }
                //일간/주간 뷰 선택
                Picker("daily or weekly", selection: $pickView){
                    ForEach(views, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .cornerRadius(15)
                
                if pickView == "일간"{
                    DailyProgressView()
                } else{
                    WeeklyProgressView()
                }
                Spacer()
            }
        }.onAppear {
            userService.fetchUserInfo()
        }
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
