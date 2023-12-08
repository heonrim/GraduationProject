//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore
import Foundation
import Firebase

@main
struct YourApp: App {
    init() {
        // 確保只調用一次
//        handleLogout()
        FirebaseApp.configure()

    }
    
    // register app delegate for Firebase setup
    @State private var shouldList = false
    @State private var hasListBeenCalled = false
    @State private var registerStep = 0
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("RegistrationView") var showRegistrationView: Bool = false
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("uid") private var uid:Int = 0
    @AppStorage("email") private var email:String = ""
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("userDescription") private var userDescription:String = ""
    @AppStorage("currentStep") private var currentStep:Int = 0
    @AppStorage("create_at") private var create_at:String = ""
    @AppStorage("image") private var image:String = "appstore"
    
    
    @StateObject var taskStore = TaskStore()
    @StateObject var todoStore = TodoStore()
    @StateObject var sportStore = SportStore()
    @StateObject var dietStore = DietStore()
    @StateObject var routineStore = RoutineStore()
    @StateObject var tickerStore = TickerStore()
    @StateObject var communityStore = CommunityStore()
    @StateObject var completionRates = CompletionRatesViewModel()
    @StateObject private var tabBarSettings = TabBarSettings()
    @State private var tabBarHidden = true
    var body: some Scene {
        WindowGroup {
            if !isSignIn || email == "" {
                LoginView()
                    .onAppear() {
                        handleLogout()
                    }
                
            } else {
                if (create_at != "") {
//                    HomeView( tabBarHidden: $tabBarHidden)
                    TabBarView()
                        .environmentObject(taskStore)
                        .environmentObject(todoStore)
                        .environmentObject(sportStore)
                        .environmentObject(dietStore)
                        .environmentObject(tickerStore)
                        .environmentObject(routineStore)
                        .environmentObject(communityStore)
                        .environmentObject(completionRates)
                        .environmentObject(tabBarSettings)
                        .onAppear() {
                            fetchDataIfNeeded()
                            printUserInfo()
                        }
                } else if (currentStep == 5) {
                    WelcomeView()
                        .onAppear() {
                            printUserInfo()
                        }
                    
                } else if (currentStep != 0) {
                    StoryContentView()
                        .onAppear() {
                            printUserInfo()
                        }
                    
                } else if (userName == "" || userDescription == "" ) {
                    RegistrationView()
                        .onAppear() {
                            printUserInfo()
                        }
                    
                } else if (currentStep == 0) {
                    IntroAnimationView()
                        .onAppear() {
                            printUserInfo()
                        }
                }
                
            }
        }
    }
    private func handleLogout() {
        shouldList = false
        taskStore.clearTasks()
        todoStore.clearTodos()
        sportStore.clearTodos()
        dietStore.clearTodos()
        routineStore.clearTodos()
        communityStore.clearTodos()
        completionRates.clearTodos()
        tickerStore.clearTodos()
        UserDefaults.standard.set("", forKey: "uid")
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("", forKey: "userDescription")
        UserDefaults.standard.set(0, forKey: "currentStep")
        UserDefaults.standard.set("", forKey: "create_at")

    }
    
    private func fetchDataIfNeeded() {
        if !shouldList {
            startList()
            shouldList = true
        }
    }
    
    private func printUserInfo() {
//        print("AppView-AppStorageUid:\(uid)")
//        print("AppView-AppStorageUserName:\(userName)")
        //        print("AppView-AppStoragePassword:\(password)")
        let values = """
        Show Registration View: \(showRegistrationView)
        Is Signed In: \(isSignIn)
        UID: \(uid)
        Email: \(email)
        User Name: \(userName)
        User Description: \(userDescription)
        Current Step: \(currentStep)
        Create At: \(create_at)
        """
        print(values)
    }
    
    private func printResultMessage(for message: String, withOperationName operationName: String) {
        if message == "Success" {
            print("\(operationName) Success")
        } else {
            print("\(operationName) failed with message: \(message)")
        }
    }
    
    private func startList() {
//        list(taskStore: taskStore, todoStore: todoStore, sportStore: sportStore, dietStore: dietStore, routineStore: routineStore)
        RoutineList { dietListMessage in
            printResultMessage(for: dietListMessage, withOperationName: "RoutineList")
        }
        DietList { dietListMessage in
            printResultMessage(for: dietListMessage, withOperationName: "DietList")
        }
        SportList { sportListMessage in
            printResultMessage(for: sportListMessage, withOperationName: "SportList")
        }
        StudyGeneralList { generalListMessage in
            printResultMessage(for: generalListMessage, withOperationName: "StudyGeneralList")
        }
        StudySpaceList { spaceListMessage in
            printResultMessage(for: spaceListMessage, withOperationName: "StudySpaceList")
        }
        tickersList { tickersListMessage in
            printResultMessage(for: tickersListMessage, withOperationName: "TickersList")
        }
       
        CommunityList { spaceListMessage in
            printResultMessage(for: spaceListMessage, withOperationName: "CommunityList")
        }
    }
    
    func StudySpaceList(completion: @escaping (String) -> Void) {
       let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudySpaceList" ,type: "list",body:body,store: taskStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    func StudyGeneralList(completion: @escaping (String) -> Void) {
       let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudyGeneralList",type: "list",body:body,store: todoStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    func SportList(completion: @escaping (String) -> Void) {
                let body: [String: Any] = ["uid": uid]

        phpUrl(php: "SportList",type: "list",body:body,store: sportStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    func DietList(completion: @escaping (String) -> Void) {
       let body: [String: Any] = ["uid": uid]
        phpUrl(php: "DietList",type: "list",body:body,store: dietStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            // completion(message[0])
            completion(message["message"]!)
        }
    }
    
    func RoutineList(completion: @escaping (String) -> Void) {
       let body: [String: Any] = ["uid": uid]
        phpUrl(php: "RoutineList",type: "list",body:body,store: routineStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            // completion(message[0])
            completion(message["message"]!)
        }
    }
    
   func tickersList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "tickersList",type: "list",body:body,store: tickerStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            //// completion(message[0])
            completion(message["message"]!)
        }
    }
   func CommunityList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "CommunityList",type: "list",body:body,store: communityStore){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            //// completion(message[0])
            completion(message["message"]!)
        }
    }
}

