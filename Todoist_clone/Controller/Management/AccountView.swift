//
//  AccountView.swift
//  Todoist_clone
//
//  Created by eastroot on 3/4/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore

struct AccountView: View {
    @ObservedObject var todoListViewModel: TodoListViewModel
    @State private var isLoggedIn = false
    @State private var user: User? = nil // Firebase User 정보 저장
    @Environment(\.dismiss) var dismiss // 🔙 화면 닫기s
    
    
    var body: some View {
        VStack {
            if isLoggedIn {
                // ✅ 로그인된 상태 → 계정 정보 뷰
                ProfileView(todoListViewModel: todoListViewModel, user: user)
            } else {
                // ❌ 로그인되지 않은 상태 → 구글 로그인 버튼 표시
                VStack {
                    Text("로그인이 필요합니다.")
                        .font(.title2)
                        .padding()
                    
                    Button(action: {
                        signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("구글 계정으로 로그인")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            checkLoginStatus()
        }
        .navigationTitle("내 계정")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }){
            HStack {
                Image(systemName: "chevron.left")
                Text("뒤로")
            }
        }
        )
        
    }
    
    // ✅ 로그인 상태 체크
    func checkLoginStatus() {
        if let currentUser = Auth.auth().currentUser {
            self.user = currentUser
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    // ✅ 구글 로그인 기능
    func signInWithGoogle() {
        // Firebase Google 로그인 로직 (Google Sign-In SDK)
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // ✅ 현재 최상위 ViewController 가져오기
        guard let presentingVC = UIApplication.shared.topViewController() else {
            print("❌ 현재 화면을 찾을 수 없음")
            return
        }
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            
            if let error = error {
                print("❌ Google 로그인 실패: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("❌ Google 사용자 정보를 가져올 수 없음")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            // ✅ Firebase Auth에 로그인
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase 로그인 실패: \(error.localizedDescription)")
                    return
                }
                // Firebase에 유저 정보 저장
                            saveUserInfoToFirestore(user: user)
                // ✅ 메인 스레드에서 UI 업데이트
                DispatchQueue.main.async {
                    self.user = Auth.auth().currentUser
                    self.isLoggedIn = true
                }
            }
        }
    }
    // Firestore에 유저 정보 저장
    func saveUserInfoToFirestore(user: GIDGoogleUser) {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(firebaseUser.uid)
        
        // Firestore에 저장할 유저 정보
        let userData: [String: Any] = [
            "name": user.profile?.name ?? "이름 없음",
            "email": user.profile?.email ?? "이메일 없음",
            "photoURL": user.profile?.imageURL(withDimension: 200)?.absoluteString ?? "사진 없음",
            "joinDate": Date(),
            "taskCount": 0 // 기본값으로 설정
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                print("❌ Firestore에 유저 정보 저장 실패: \(error.localizedDescription)")
            } else {
                print("✅ Firestore에 유저 정보 저장 성공")
            }
        }
    }
}

#Preview {
   // AccountView()
}
