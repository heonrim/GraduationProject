//
//  ReviseTask.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/3.
//

import Foundation
import UserNotifications

func handleStudySpaceRevise(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleReviseData(data: data, messageType: .reviseSpace, completion: completion)
}

func handleGeneralRevise(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleReviseData(data: data, messageType: .reviseTask, completion: completion)
}

func handleDeleteTodo(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleDeleteData(data: data, messageType: .deleteTask, completion: completion)
}
func handleUpDateCompleteValue(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleUpDateValue(data: data, messageType: .upDateCompleteValue, completion: completion)
}
func handleReviseProfile(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleReviseProfileData(data: data, messageType: .reviseProfile, completion: completion)
}

func handleReviseData(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(ReviseData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            if  let reminderTime = convertToTimeM(userData.reminderTime ) {
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle, body: userData.todoIntroduction,tid: String(userData.todo_id), isRemove: true)
            } else {
                completion(["message":"reviseTaskFail"])
                print("handleReviseData - 日期或時間轉換失敗")
            }
            completion(["message":Message.success.rawValue])
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}

func handleDeleteData(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(DeleteData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(userData.todo_id)])
            completion(["message":Message.success.rawValue])
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}


func handleReviseProfileData(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(UserData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            UserDefaults.standard.set("\(userData.userName ?? "")", forKey: "userName")
            UserDefaults.standard.set("\(userData.userDescription ?? "")", forKey: "userDescription")
            UserDefaults.standard.set(userData.image ?? "", forKey: "image")
            completion(["message":Message.success.rawValue])
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}

func handleUpDateValue(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(UpdateValueData.self, data: data) { userData in
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
//            completion([Message.success.rawValue])
            completion(["message":Message.success.rawValue])
            print("============== \(messageType.rawValue) ==============")
        } else {
//            completion([userData.message])
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}
