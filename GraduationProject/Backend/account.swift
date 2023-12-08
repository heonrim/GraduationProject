//
//  account.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/3.
//

import Foundation
import SwiftSMTP

enum Message: String {
    case login = "User login successfully"
    case registerGmail = "User registerGmail successfully"
    case wrongPass = "Invalid password"
    case wrongEmail = "No such account"
    
    case success = "Success"
    
    case userRegistered = "User registered successfully"
    case emailRegistered = "email is registered"
    case updateUsername = "User updateUsername successfully"
    case updateUserDescription = "User updateUserDescription successfully"
    case updateCurrentStep = "User updateCurrentStep successfully"
    case updateCreateAt = "User updateCreateAt successfully"
    
    case newTask = "User New Task successfully"
    case reTask = "The Todo is repeated"
    
    case newCommunity = "User New Community successfully"
    case reCommunity = "The Community is repeated"
    
    case deleteTask = "Todo data deleted successfully"
    case reviseTask = "User revise Task successfully"
    case reviseSpace = "User revise Space successfully"
    case reviseProfile = "User reviseProfile successfully"
    case upDateCompleteValue = "User upDateCompleteValue successfully"

    case TrackingFirstDay = "User TrackingFirstDay successfully"
    case RecurringCheckList = "User RecurringCheckList successfully"
}

struct MailConfig {
    static let smtpHostname = "smtp.gmail.com"
    static let smtpEmail = "3430yun@gmail.com"
    static let smtpPassword = "knhipliavnpqxwty"
}
func sendEmail(verify: String,mail: String,completion: @escaping (String, String) -> Void) {
    DispatchQueue.global().async {
        generateRandomVerificationCode() { randomMessage in
            let verify = randomMessage
            sendMail(verify: verify, mail: mail) { message in
                if message == Message.success.rawValue {
                    print("Send - 隨機變數為：\(verify)")
                }
                completion(verify, message)
            }
        }
    }
}
func generateRandomVerificationCode( completion: @escaping (String) -> Void) {
    let verify = Int.random(in: 1..<99999999)
    print("regiest - 隨機變數為：\(verify)")
    completion(String(verify))
}
func sendMail(verify: String,mail: String,completion: @escaping (String) -> Void) {
    let smtp = SMTP(
        hostname: MailConfig.smtpHostname,
        email: MailConfig.smtpEmail,
        password: MailConfig.smtpPassword
    )
    print("mail:\(mail)")
    let megaman = Mail.User(name: "我習慣了使用者", email: mail)
    let drLight = Mail.User(name: "Yun", email: "3430yun@gmail.com")
    let mail = Mail(
        from: drLight,
        to: [megaman],
        subject: "歡迎使用我習慣了！這是您的驗證信件",
        text: "以下是您的驗證碼： \(String(verify))"
    )
    
    smtp.send(mail) { error in
        if let error = error {
            print("regiest - \(error)")
            completion(error.localizedDescription)
        } else {
            completion(Message.success.rawValue)
            print("SEND: SUBJECT: \(mail.subject)")
            print("SEND: SUBJECT: \(mail.text)")
            print("FROM: \(mail.from)")
            print("TO: \(mail.to)")
            print("Send email successful")
        }
    }
}

func handleLogin(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleUserData(data: data, messageType: .login, completion: completion)
}

func handleRegister(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleUserData(data: data, messageType: .userRegistered, completion: completion)
}

func handleUserData(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(UserData.self, data: data) { userData in
        
        print("============== \(userData.message) ==============")
        print("\(userData.message) - userDate:\(userData)")
        
        if userData.message == Message.userRegistered.rawValue {
            UserDefaults.standard.set(userData.id, forKey: "uid")
            UserDefaults.standard.set(userData.email, forKey: "email")
            completion(["message":Message.userRegistered.rawValue])
            
        } else if userData.message == Message.registerGmail.rawValue {
            UserDefaults.standard.set(userData.id, forKey: "uid")
            UserDefaults.standard.set(userData.email, forKey: "email")
            completion(["message":Message.registerGmail.rawValue])
        } else if userData.message == Message.login.rawValue {
            UserDefaults.standard.set(userData.id, forKey: "uid")
            UserDefaults.standard.set(userData.email, forKey: "email")
            completion(["message":Message.login.rawValue])
        } else if userData.message == Message.wrongPass.rawValue {
            completion(["message":Message.wrongPass.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else if userData.message == Message.wrongEmail.rawValue {
            completion(["message":Message.wrongEmail.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else if userData.message == Message.emailRegistered.rawValue {
            completion(["message":Message.emailRegistered.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else  if userData.message == Message.updateUsername.rawValue {
            completion(["message":Message.updateUsername.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else if userData.message == Message.updateUserDescription.rawValue {
            completion(["message":Message.updateUserDescription.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else if userData.message == Message.updateCurrentStep.rawValue {
            completion(["message":Message.updateCurrentStep.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else if userData.message == Message.updateCreateAt.rawValue {
            completion(["message":Message.updateCreateAt.rawValue])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }

        UserDefaults.standard.set(userData.userName ?? "", forKey: "userName")
        UserDefaults.standard.set(userData.userDescription ?? "", forKey: "userDescription")
        UserDefaults.standard.set(userData.currentStep ?? 0, forKey: "currentStep")
        UserDefaults.standard.set(userData.create_at ?? "", forKey: "create_at")
        UserDefaults.standard.set(userData.image ?? "", forKey: "image")
        UserDefaults.standard.set(true, forKey: "signIn")
        
        // 然后在同一作用域中调用它
        let keys = ["uid", "email", "userName", "userDescription", "currentStep", "create_at", "signIn"]
        for key in keys {
            printUserDefaultsValue(forKey: key)
        }
        print("============== \(userData.message) ==============")
    }
}



func printUserDefaultsValue(forKey key: String) {
    let userDefaults = UserDefaults.standard
    
    if let value = userDefaults.object(forKey: key) {
        print("UserDefaults 中键 '\(key)' 的值为: \(value)")
    } else {
        print("UserDefaults 中没有找到键 '\(key)' 的值。")
    }
}

