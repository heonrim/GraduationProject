//
//  AddTask.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/29.
//

import Foundation

// 定義一個通用的函數處理頻率轉換
func convertFrequency(frequency: Int) -> String {
    switch frequency {
    case 1:
        return "每日"
    case 2:
        return "每週"
    case 3:
        return "每月"
    default:
        return ""
    }
}

func addRecurringEndDate(frequency:Int,startDate:Date) -> Date {
    switch frequency {
    case 1:
        let RecurringEndDate =  (Calendar.current.date(byAdding: .day, value: 0, to: startDate))!
        return RecurringEndDate
    case 2:
        let RecurringEndDate =  (Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startDate))!
        return RecurringEndDate
    case 3:
        let RecurringEndDate =  (Calendar.current.date(byAdding: .month, value: 1, to: startDate))!
        return RecurringEndDate
    default:
        return Date()
    }
}

// 定義一個通用的函數處理重複選項計算
func calculateRecurringOption(dueDateTime: Date, startDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: startDate, to: dueDateTime)
    return components.year! >= 5 ? 2 : 1
}

// 定義一個通用的函數處理狀態轉換
func convertTodoStatus(todoStatus: Int) -> Bool {
    return todoStatus != 0
}

func handleStudySpaceAdd(data: Data,store: TaskStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(addTaskData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == Message.newTask.rawValue) {
            let ReviewChecked0 = false
            let ReviewChecked1 = false
            let ReviewChecked2 = false
            let ReviewChecked3 = false
            if let startDate = convertToDate(userData.startDateTime),
               let repetition1Count = convertToDate(userData.repetition1Count),
               let repetition2Count = convertToDate(userData.repetition2Count),
               let repetition3Count = convertToDate(userData.repetition3Count),
               let repetition4Count = convertToDate(userData.repetition4Count),
               let reminderTime = convertToTimeM(userData.reminderTime) {
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle, body: userData.todoIntroduction,tid: String(userData.todo_id), isRemove: false)
                let task = Task(id: userData.todo_id,
                                label: userData.todoLabel ?? "",
                                title: userData.todoTitle,
                                description: userData.todoIntroduction,
                                nextReviewDate: startDate, nextReviewTime: reminderTime,
                                repetition1Count: repetition1Count, repetition2Count: repetition2Count,
                                repetition3Count: repetition3Count, repetition4Count: repetition4Count,
                                isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1,
                                isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                DispatchQueue.main.async {
                    store.tasks.append(task)
                }
                 completion(["message":Message.success.rawValue])
            } else {
                completion(["message":"AddTaskConvertFail"])
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        } else if (userData.message == Message.reTask.rawValue) {
            completion(["message":Message.reTask.rawValue])
        } else {
            completion(["message":userData.message])
        }
    }
}

func handleStudyGeneralAdd(data: Data,store: TodoStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(addTodoData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == Message.newTask.rawValue) {
            var studyUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime),
               let dueDateTime = convertToDate(userData.dueDateTime),
               let reminderTime = convertToTimeM(userData.reminderTime) {
                
                let frequency = userData.frequency
                let recurringUnit = convertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)
                let RecurringEndDate = addRecurringEndDate(frequency: frequency, startDate: startDate)
                
                if (userData.studyUnit == 0 ){
                    studyUnit = "小時"
                } else  if (userData.studyUnit == 1 ) {
                    studyUnit = "次"
                }
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle, body: userData.todoIntroduction,tid: String(userData.todo_id), isRemove: false)
                let todo = Todo(id: userData.todo_id,
                                label: userData.todoLabel ?? "",
                                title: userData.todoTitle,
                                description: userData.todoIntroduction,
                                startDateTime: startDate,
                                studyValue: userData.studyValue,
                                studyUnit: studyUnit,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote ?? "",
                                RecurringStartDate: startDate,
                                RecurringEndDate: RecurringEndDate,
                                completeValue:  0)
                DispatchQueue.main.async {
                    store.todos.append(todo)
                }
                 completion(["message":Message.success.rawValue])
            } else {
                completion(["message":"AddTaskConvertFail"])
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        } else if (userData.message == Message.reTask.rawValue) {
            completion(["message":Message.reTask.rawValue])
        } else {
            completion(["message":userData.message])
        }
    }
}

func handleSportAdd(data: Data,store: SportStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(addSportData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == Message.newTask.rawValue) {
            var sportUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let reminderTime = convertToTimeM(userData.reminderTime ) {
                
                let frequency = userData.frequency
                let recurringUnit = convertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)
                let RecurringEndDate = addRecurringEndDate(frequency: frequency, startDate: startDate)
                
                if (userData.sportUnit  == 0 ){
                    sportUnit = "小時"
                } else  if (userData.sportUnit  == 1 ) {
                    sportUnit = "次"
                } else  if (userData.sportUnit  == 2 ) {
                    sportUnit = "卡路里"
                }
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle, body: userData.todoIntroduction,tid: String(userData.todo_id), isRemove: false)
                let sport = Sport(id: userData.todo_id,
                                  label: userData.todoLabel ?? "",
                                  title: userData.todoTitle ,
                                  description: userData.todoIntroduction ,
                                  startDateTime: startDate,
                                  selectedSport: userData.sportType ,
                                  sportValue: userData.sportValue ,
                                  sportUnits: sportUnit,
                                  recurringUnit: recurringUnit,
                                  recurringOption: recurringOption,
                                  todoStatus: isTodoStatus,
                                  dueDateTime: dueDateTime,
                                  reminderTime: reminderTime,
                                  todoNote: userData.todoNote ?? "" ,
                                  RecurringStartDate: startDate,
                                  RecurringEndDate: RecurringEndDate,
                                  completeValue:  0)
                DispatchQueue.main.async {
                    store.sports.append(sport)
                }
                 completion(["message":Message.success.rawValue])
            } else {
                completion(["message":"AddTaskConvertFail"])
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        } else if (userData.message == Message.reTask.rawValue) {
            completion(["message":Message.reTask.rawValue])
        } else {
            completion(["message":userData.message])
        }
    }
}

func handleDietAdd(data: Data,store: DietStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(addDietData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == Message.newTask.rawValue) {
            
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let reminderTime = convertToTimeM(userData.reminderTime ) {
                
                let frequency = userData.frequency
                let recurringUnit = convertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)
                let RecurringEndDate = addRecurringEndDate(frequency: frequency, startDate: startDate)
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle, body: userData.todoIntroduction,tid: String(userData.todo_id), isRemove: false)
                let diet = Diet(id: userData.todo_id,
                                label: userData.todoLabel ?? "",
                                title: userData.todoTitle ,
                                description: userData.todoIntroduction ,
                                startDateTime: startDate,
                                selectedDiets: userData.dietType ,
                                dietsValue: userData.dietValue,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote ?? "" ,
                                RecurringStartDate: startDate,
                                RecurringEndDate: RecurringEndDate,
                                completeValue:  0)
                DispatchQueue.main.async {
                    store.diets.append(diet)
                }
                 completion(["message":Message.success.rawValue])
            } else {
                completion(["message":"AddTaskConvertFail"])
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        } else if (userData.message == Message.reTask.rawValue) {
            completion(["message":Message.reTask.rawValue])
        } else {
            completion(["message":userData.message])
        }
    }
}
func handleRoutineAdd(data: Data,store: RoutineStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(addRoutineData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == Message.newTask.rawValue) {
            
            if let startDate = convertToDate(userData.startDateTime ),
               let dueDateTime = convertToDate(userData.dueDateTime ),
               let routinesTime = convertToTimeM(userData.routineTime ),
               let reminderTime = convertToTimeM(userData.reminderTime ) {
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus
                let isTodoStatus = convertTodoStatus(todoStatus: todoStatus)
                let RecurringEndDate = addRecurringEndDate(frequency: 0, startDate: startDate)
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle, body: userData.todoIntroduction,tid: String(userData.todo_id), isRemove: false)
                let routine = Routine(id: userData.todo_id,
                                      label: userData.todoLabel ?? "",
                                      title: userData.todoTitle ,
                                      description: userData.todoIntroduction ,
                                      startDateTime: startDate,
                                      selectedRoutines: userData.routineType ,
                                      routineValue: userData.routineValue,
                                      routineTime: routinesTime,
                                      recurringOption: recurringOption,
                                      todoStatus: isTodoStatus,
                                      dueDateTime: dueDateTime,
                                      reminderTime: reminderTime,
                                      todoNote: userData.todoNote ?? "" ,
                                      RecurringStartDate: startDate,
                                      RecurringEndDate: RecurringEndDate,
                                      sleepTime: nil,
                                      wakeUpTime: nil)
                DispatchQueue.main.async {
                    store.routines.append(routine)
                }
                 completion(["message":Message.success.rawValue])
            } else {
                completion(["message":"AddTaskConvertFail"])
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        } else if (userData.message == Message.reTask.rawValue) {
            completion(["message":Message.reTask.rawValue])
        } else {
            completion(["message":userData.message])
        }
    }
}

func handleCommunityAdd(data: Data,store: CommunityStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(addCommunityData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == Message.newCommunity.rawValue) {
            
            let task = Community(id: userData.community_id,
                                 communityName: userData.communityName,
                                 communityDescription: userData.communityDescription,
                                 communityCategory: userData.communityCategory,
                                 image: userData.image,
                                 isMember: "true")
            DispatchQueue.main.async {
                store.communitys.append(task)
            }
             completion(["message":Message.newCommunity.rawValue])
        } else if (userData.message == Message.reCommunity.rawValue) {
            completion(["message":Message.reCommunity.rawValue])
        } else {
            print("DietList - 日期或時間轉換失敗")
            completion(["message":"AddCommunityFail"])
        }
    }
}

func handleAutoAdd(data: Data, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(autoAddData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if (userData.message == "User New first RecurringInstance successfully") {
            completion(["message":"User New first RecurringInstance successfully"])
        } else {
            completion(["message":"今日無需新增"])
        }
    }
}
