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
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let presentingVC = UIApplication.shared.topViewController() else {
            print("🔍 현재 최상위 뷰 컨트롤러: \(String(describing: UIApplication.shared.topViewController()))")
            print("❌ 현재 화면을 찾을 수 없음")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                print("❌ Google 로그인 실패: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Google 사용자 정보를 가져올 수 없음")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase 로그인 실패: \(error.localizedDescription)")
                    return
                }

                // ✅ Firestore에 사용자 정보 저장
                saveUserInfoToFirestore(user: user) { success in
                    DispatchQueue.main.async {
                        self.user = Auth.auth().currentUser
                        self.isLoggedIn = true
                        print("✅ 로그인 성공 후 UI 업데이트 완료!")
                    }
                }
            }
        }
    }
    func saveUserInfoToFirestore(user: GIDGoogleUser, completion: @escaping (Bool) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(firebaseUser.uid)

        userRef.getDocument { document, error in
            if let error = error {
                print("❌ Firestore 유저 정보 조회 실패: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let document = document, document.exists, document.data()?["joinDate"] != nil {
                print("✅ 기존 유저, joinDate 업데이트 안 함")
                completion(true)
                return
            }

            let userData: [String: Any] = [
                "name": user.profile?.name ?? "이름 없음",
                "email": user.profile?.email ?? "이메일 없음",
                "photoURL": user.profile?.imageURL(withDimension: 200)?.absoluteString ?? "사진 없음",
                "joinDate": FieldValue.serverTimestamp(),
                "taskCount": 0
            ]

            userRef.setData(userData, merge: true) { error in
                if let error = error {
                    print("❌ Firestore에 유저 정보 저장 실패: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("✅ Firestore에 유저 정보 저장 성공")
                    completion(true)
                }
            }
        }
    }
}
