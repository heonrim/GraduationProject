//
//  AppDelegate.swift
//  GraduationProject
//
//  Created by heonrim on 5/23/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import GoogleSignIn
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 配置 Firebase
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // 请求推送通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("用户已同意推送通知")
            } else {
                print("用户未同意推送通知")
            }
        }

        // 设置推送通知的代理
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }

        // 处理其他自定义 URL 类型

        // 如果未被此应用处理，返回 false
        return false
    }

    // 在这里处理接收到的推送通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 在这里处理推送通知的点击事件，显示相应的视图
        
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // 用户点击了通知，显示你想要的视图
//            TodayTasksView()
        }

        completionHandler()
    }

    // 在这里添加任何需要的额外 UNUserNotificationCenterDelegate 方法
}
