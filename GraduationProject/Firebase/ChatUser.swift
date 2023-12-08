//
//  ChatUser.swift
//  GraduationProject
//
//  Created by heonrim on 5/25/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

struct ChatUser {
    
//    var id: String { uid }
//    
//    let uid, email, profileImageUrl: String
//    
//    init(data: [String: Any]) {
//        self.uid = data["uid"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
//    }
    var uid: String
    var email: String?
    // 其他需要的屬性

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
        // 初始化其他屬性
    }
    
    static var current: ChatUser? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        let uid = currentUser.uid
        let email = currentUser.email ?? ""
        // 可以根據需要獲取其他使用者資料
        
        let data: [String: Any] = [
            "uid": uid,
            "email": email
            // 添加其他使用者資料字段
        ]
        
        return ChatUser(uid: uid,email: email)
    }
}
