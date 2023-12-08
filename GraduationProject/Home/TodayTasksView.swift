//
//  TodayTasksView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/21.
//

import SwiftUI
import Lottie

struct TodayTasksView: View {
    @AppStorage("uid") private var uid:String = ""
    @State private var previousCompletionStatus: [Int: Bool] = [:]
    @State private var remainingValues: [Int: Float] = [:]
    @ObservedObject private var taskService = TaskService.shared
    @State private var selectedTaskId: Int?
    
    @State private var playAnimation1: Bool = false //完成
    let animation1: String = "animation_lmvsn755"
    @State private var playAnimation2: Bool = false //繼續加油
    let animation2: String = "Animation - 1696509945910"
    @State private var playAnimation3: Bool = false //睡覺
    let animation3: String = "Animation - 1696502172126"
    @State private var playAnimation4: Bool = false //起床
    let animation4: String = "Animation - 1696502129829"
    @State private var playAnimation5: Bool = false //失敗
    let animation5: String = "Animation - 1696509680179"
    
    @EnvironmentObject var tabBarSettings: TabBarSettings
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @State private var filteredSports: [Sport] = []
    @State var tasksForToday: [Task] = []
    var cardSpacing: CGFloat = 5
    var  sampleSport = Sport(
        id: 1,
        label: "SampleLabel",
        title: "SampleTitle",
        description: "SampleDescription",
        startDateTime: Date(),
        selectedSport: "Running",
        sportValue: 5.0,
        sportUnits: "times",
        recurringUnit: "daily",
        recurringOption: 1,
        todoStatus: false,
        dueDateTime: Date(),
        reminderTime: Date(),
        todoNote: "SampleNote",
        RecurringStartDate: Date(),
        RecurringEndDate: Date(),
        completeValue: 0.0
    )
    var body: some View {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: cardSpacing) {
                        ForEach(Array(tasksForToday.enumerated()), id: \.element.id) { index, task in
                            HStack{
                                getTaskView(task: task,type: "spaced")
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)  // Adjusted size here
                                    .cornerRadius(10)
                                    .onReceive(CheckSpaceView.remainingValuePublisher) { isCompleted in
                                        
                                        if isCompleted == true {
                                            print("Setting playAnimation to true")
                                            playAnimation1 = true
                                        } else {
                                            playAnimation2 = true
                                        }
                                    }
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                        
                        ForEach(todoStore.todosForDate(Date()), id: \.id) { task in
                            HStack{
                                getTaskView(task: task,type: "study")
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                                    .cornerRadius(10)
                                    .onReceive(CheckStudyView.remainingValuePublisher) { (isCompleted) in
                                        
                                        if isCompleted == true {
                                            print("Setting playAnimation to true")
                                            playAnimation1 = true
                                        } else {
                                            playAnimation2 = true
                                        }
                                    }
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                        
                        ForEach(sportStore.sportsForDate(Date()), id: \.id) { task in
                            HStack{
                                getTaskView(task: task,type: "sport")
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                                    .cornerRadius(10)
                                    .onReceive(CheckSportView.remainingValuePublisher) { (isCompleted) in
                                        
                                        if isCompleted == true {
                                            print("Setting playAnimation to true")
                                            playAnimation1 = true
                                        } else {
                                            playAnimation2 = true
                                        }
                                    }
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                        
                        ForEach(dietStore.dietForDate(Date()), id: \.id) { task in
                            HStack{
                                getTaskView(task: task,type: "diet")
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                                    .cornerRadius(10)
                                    .onReceive(CheckDietView.remainingValuePublisher) { isCompleted,isFail,dietType in
                                        
                                        switch dietType {
                                        case "減糖", "少油炸":
                                            if isCompleted == true {
                                                playAnimation2 = true
                                            } else {
                                                print("Setting playAnimation to true")
                                                playAnimation5 = true
                                            }
                                        case "多喝水", "多吃蔬果":
                                            if isCompleted == true {
                                                print("Setting playAnimation to true")
                                                playAnimation1 = true
                                            } else {
                                                playAnimation2 = true
                                            }
                                        default:
                                            break
                                        }
                                    }
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                        ForEach(routineStore.routineForDate(Date()), id: \.id) { task in
                            HStack{
                                getTaskView(task: task,type: "routine")
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                                    .cornerRadius(10)
                                    .onReceive(CheckSleepView.remainingValuePublisher) { isCompleted,routineType in
                                        
                                        switch routineType {
                                        case 0:
                                            if isCompleted == true {
                                                playAnimation3 = true
                                            } else {
                                                print("Setting playAnimation to true")
                                                playAnimation5 = true
                                            }
                                        case 1:
                                            if isCompleted == true {
                                                playAnimation4 = true
                                            } else {
                                                print("Setting playAnimation to true")
                                                playAnimation5 = true
                                            }
                                        case 2:
                                            if isCompleted == true {
                                                print("Setting playAnimation to true")
                                                playAnimation1 = true
                                            } else {
                                                playAnimation2 = true
                                            }
                                        case 3:
                                            if isCompleted == true {
                                                print("睡眠時長")
                                                playAnimation1 = true
                                            } else {
                                                print("睡眠時長")
                                                playAnimation5 = true
                                            }
                                        default:
                                            break
                                        }
                                    }
                            }
                            .onAppear() {
                                print("RoutineStore: \(task)")
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                    }
                    .onAppear() {
                        tasksForToday = taskStore.tasksForDate(Date())
                    }
                    .padding(.horizontal, 15)
                }
                .background(
                    LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationBarTitle("今日習慣任務", displayMode: .inline)
                .navigationBarTitleDisplayMode(.inline)
                
                if playAnimation1 {
                    VStack {
                        Text("恭喜！任務完成！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation1))
                            .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    withAnimation {
                                        playAnimation1 = false
                                    }
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation2 {
                    VStack {
                        Text("加油！繼續前進！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation2))
                            .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation2 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation3 {
                    VStack {
                        Text("晚安！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation3))
                            .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation3 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation4 {
                    VStack {
                        Text("早安！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation4))
                            .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation4 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
                if playAnimation5 {
                    VStack {
                        Text("失敗！")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        LottieView(animation: .named(animation5))
                            .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                            .animationDidFinish { _ in
                                withAnimation {
                                    playAnimation5 = false
                                }
                            }
                            .frame(width: 200, height: 200)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                }
            }
            .onAppear {
                autoAdd{_ in }
                tabBarSettings.isHidden = true
                self.filteredSports = sportStore.sportsForDate(Date())
            }
            .onDisappear {
                tabBarSettings.isHidden = false
            }
    }
    func autoAdd(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [:]
        phpUrl(php: "autoAdd" ,type: "addTask",body:body, store: nil){ message in
            print("自動新增回傳：\(String(describing: message["message"]))")
            if message["message"] == "User New first RecurringInstance successfully" {
                List()
            }
            completion(message["message"]!)
        }
    }
    func getTaskView(task: Any, type: String) -> some View {
        let taskView: AnyView
        switch type {
        case "spaced":
            taskView = AnyView(CheckSpaceView(task: task as! Task))
        case "study":
            taskView = AnyView(CheckStudyView(task: task as! Todo))
        case "sport":
            taskView =  AnyView(CheckSportView( completeValue: 0.0, task: task as! Sport))
        case "diet":
            taskView =  AnyView(CheckDietView( task: task as! Diet))
        default:
            taskView =  AnyView(CheckSleepView( task: task as! Routine))
        }
        
        return taskView
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func printResultMessage(for message: String, withOperationName operationName: String) {
        if message == "Success" {
            print("\(operationName) Success")
        } else {
            print("\(operationName) failed with message: \(message)")
        }
    }
    
    private func List() {
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
    }
    
    func StudySpaceList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudySpaceList" ,type: "list",body:body,store: taskStore){ message in
            completion(message["message"]!)
        }
    }
    
    func StudyGeneralList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "StudyGeneralList",type: "list",body:body,store: todoStore){ message in
            completion(message["message"]!)
        }
    }
    
    func SportList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "SportList",type: "list",body:body,store: sportStore){ message in
            completion(message["message"]!)
        }
    }
    
    func DietList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "DietList",type: "list",body:body,store: dietStore){ message in
            completion(message["message"]!)
        }
    }
    
    func RoutineList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
        phpUrl(php: "RoutineList",type: "list",body:body,store: routineStore){ message in
            completion(message["message"]!)
        }
    }
}

struct TodayTasksView_Previews: PreviewProvider {
    static var previews: some View {
        TodayTasksView()
            .environmentObject(TaskService.shared)
    }
}
