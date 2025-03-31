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
        }
    }
    
    
    // ✅ 완료한 업무 개수 가져오기
    func getCompletedTaskCount() -> Int {
        // CoreData에서 완료된 업무 개수
        let count: Int = todoListViewModel.completedItems.count
        return count
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

//#Preview {
//    ProfileView()
//}
