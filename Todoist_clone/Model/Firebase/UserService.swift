//
//  UserService.swift
//  Todoist_clone
//
//  Created by eastroot on 3/27/25.
//

import FirebaseFirestore
import FirebaseAuth

class UserService: ObservableObject {
    static var shared = UserService()
    
    let db = Firestore.firestore()
    
    @Published var currentUser: Consumer?
    
    
    func saveUserInfo(name: String, email: String, joinDate: Date, taskCount: Int) {
        guard let user = Auth.auth().currentUser else {
            print("🚨 유저 없음!")
            return
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "joinDate": joinDate,
            "taskCount": taskCount
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                print("❌ Firestore 저장 오류: \(error.localizedDescription)")
            } else {
                print("✅ Firestore에 유저 정보 저장 성공")
            }
        }
    }
    
    // ✅ Firestore에서 유저 정보 불러오기
    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else {
            print("🚨 유저 없음!")
            return
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("🚨 Firestore 오류: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data() else {
                print("🚨 데이터 없음!")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                if let name = data?["name"] as? String,
                   let email = data?["email"] as? String,
                   let joinDateTimestamp = data?["joinDate"] as? Timestamp,
                   let taskCount = data?["taskCount"] as? Int {
                    
                    let joinDate = joinDateTimestamp.dateValue()
                    let elapsedDays = Calendar.current.dateComponents([.day], from: joinDate, to: Date()).day ?? 0
                    let rank = self.calculateRank(taskCount: taskCount, days: elapsedDays)
                    DispatchQueue.main.async {
                        self.currentUser = Consumer(id: user.uid, name: name, email: email, joinDate: joinDate, taskCount: taskCount, rank: rank)
                        print("✅ 유저 정보 로드 성공: \(user)")
                    }
                }
            }
        }
    }
    
    // ✅ Firestore에 할 일 개수 업데이트
    func updateTaskCount(_ count: Int) {
        guard let user = Auth.auth().currentUser else { return }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.updateData([
            "taskCount": count,
            "rank": calculateRank(taskCount: count, days: calculateDaysSinceJoin())
        ]) { error in
            if let error = error {
                print("❌ Firestore 업데이트 오류: \(error)")
            } else {
                print("✅ Firestore에 할 일 개수 업데이트 완료!")
            }
        }
    }
    
    // ✅ 등급 계산 로직
    private func calculateRank(taskCount: Int, days: Int) -> String {
        if days >= 365 { return "VIP" } // 1년 이상 이용자
        if taskCount > 100 { return "Platinum" }
        if taskCount > 50 { return "Gold" }
        if taskCount > 10 { return "Silver" }
        return "Bronze"
    }
    
    // ✅ 가입 후 지난 일수 계산
    private func calculateDaysSinceJoin() -> Int {
        guard let joinDate = currentUser?.joinDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: joinDate, to: Date()).day ?? 0
    }
}
