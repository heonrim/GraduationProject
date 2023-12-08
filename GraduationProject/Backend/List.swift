//
//  List.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/29.
//

import Foundation
import UserNotifications

func scheduleNotificationIfNeeded(alert_time: Date, title: String, body: String,tid: String, isRemove: Bool) {
    var notificationScheduled = false
    guard !notificationScheduled else {
        return
    }
    if isRemove {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [tid])
    }
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([ .hour, .minute], from: alert_time)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    
    let request = UNNotificationRequest(identifier: tid, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("無法設定推播通知: \(error)")
        } else {
            print("推播通知已設定\(title)")
            notificationScheduled = true
        }
    }
}

// 定義一個通用的函數處理頻率轉換
func ConvertFrequency(frequency: Int) -> String {
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

// 定義一個通用的函數處理狀態轉換
func ConvertTodoStatus(todoStatus: Int) -> Bool {
    return todoStatus != 0
}

func handleStudySpaceList(data: Data,store: TaskStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(TaskData.self, data: data) { userData in
        store.clearTasks()
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.todoTitle.indices {
            
            if let startDate = convertToDate(userData.startDateTime[index]),
               let repetition1Count = convertToDate(userData.repetition1Count[index]),
               let repetition2Count = convertToDate(userData.repetition2Count[index]),
               let repetition3Count = convertToDate(userData.repetition3Count[index]),
               let repetition4Count = convertToDate(userData.repetition4Count[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {
                
                let ReviewChecked0 = userData.repetition1Status[index] == 1
                let ReviewChecked1 = userData.repetition2Status[index] == 1
                let ReviewChecked2 = userData.repetition3Status[index] == 1
                let ReviewChecked3 = userData.repetition4Status[index] == 1
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle[index], body: userData.todoTitle[index],tid: String(userData.todo_id[index]), isRemove: false)
                let task = Task(id: userData.todo_id[index],label: userData.todoLabel[index]!, title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                DispatchQueue.main.async {
                    store.tasks.append(task)
                }
            } else {
                print("StudySpaceList - 日期或時間轉換失敗")
            }
        }
    }
    completion(["message":"Success"])
}

func handleStudyGeneralList(data: Data, store: TodoStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(TodoData.self, data: data) { userData in
        store.clearTodos()
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.todoTitle.indices {
            
            var studyUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let recurringStartDate = convertToDate(userData.RecurringStartDate[index]),
               let recurringEndDate = convertToDate(userData.RecurringEndDate[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {
                
                if (userData.studyUnit[index] == 0 ){
                    studyUnit = "小時"
                } else  if (userData.studyUnit[index] == 1 ) {
                    studyUnit = "次"
                }
                
                let frequency = userData.frequency[index]
                let recurringUnit = ConvertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? 0)
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle[index], body: userData.todoIntroduction[index],tid: String(userData.todo_id[index]), isRemove: false)
                let todo = Todo(id: userData.todo_id[index],
                                label: userData.todoLabel[index]!,
                                title: userData.todoTitle[index],
                                description: userData.todoIntroduction[index],
                                startDateTime: startDate,
                                studyValue:  Float(userData.studyValue[index])!,
                                studyUnit: studyUnit,
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index],
                                RecurringStartDate: recurringStartDate,
                                RecurringEndDate: recurringEndDate,
                                completeValue: Float(userData.completeValue[index]) )
                DispatchQueue.main.async {
                    store.todos.append(todo)
                }
            } else {
                print("StudyGeneralList - 日期或時間轉換失敗")
            }
        }
    }

    completion(["message":"Success"])
}


func handleSportList(data: Data,store: SportStore, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(SportData.self, data: data) { userData in
        store.clearTodos()
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.todoTitle.indices {
            
            var sportUnit: String = ""
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let recurringStartDate = convertToDate(userData.RecurringStartDate[index]),
               let recurringEndDate = convertToDate(userData.RecurringEndDate[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {
                
                if (userData.sportUnit[index] == 0 ){
                    sportUnit = "小時"
                } else  if (userData.sportUnit[index] == 1 ) {
                    sportUnit = "次"
                } else  if (userData.sportUnit[index] == 2 ) {
                    sportUnit = "卡路里"
                }
                
                let frequency = userData.frequency[index]
                let recurringUnit = ConvertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? 0)
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle[index], body: userData.todoIntroduction[index],tid: String(userData.todo_id[index]), isRemove: false)
                let sport = Sport(id: userData.todo_id[index],
                                  label: userData.todoLabel[index]!,
                                  title: userData.todoTitle[index],
                                  description: userData.todoIntroduction[index],
                                  startDateTime: startDate,
                                  selectedSport: userData.sportType[index],
                                  sportValue:  Float(userData.sportValue[index])!,
                                  sportUnits: sportUnit,
                                  recurringUnit: recurringUnit,
                                  recurringOption: recurringOption,
                                  todoStatus: isTodoStatus,
                                  dueDateTime: dueDateTime,
                                  reminderTime: reminderTime,
                                  todoNote: userData.todoNote[index],
                                  RecurringStartDate: recurringStartDate,
                                  RecurringEndDate: recurringEndDate,
                                  completeValue: Float(userData.completeValue[index]) )
                DispatchQueue.main.async {
                    store.sports.append(sport)
                }
            } else {
                print("SportList - 日期或時間轉換失敗")
            }
        }
    }
    completion(["message":"Success"])
}

func handleDietList(data: Data,store: DietStore, completion: @escaping ([String:String]) -> Void) {
    store.clearTodos()
    handleDecodableData(DietData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.todoTitle.indices {
            
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let recurringStartDate = convertToDate(userData.RecurringStartDate[index]),
               let recurringEndDate = convertToDate(userData.RecurringEndDate[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {
                
                let frequency = userData.frequency[index]
                let recurringUnit = ConvertFrequency(frequency: frequency)
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? 0)
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle[index], body: userData.todoIntroduction[index],tid: String(userData.todo_id[index]), isRemove: false)
                let diet = Diet(id: userData.todo_id[index],
                                label: userData.todoLabel[index]!,
                                title: userData.todoTitle[index],
                                description: userData.todoIntroduction[index],
                                startDateTime: startDate,
                                selectedDiets: userData.dietsType[index],
                                dietsValue: userData.dietsValue[index],
                                recurringUnit: recurringUnit,
                                recurringOption: recurringOption,
                                todoStatus: isTodoStatus,
                                dueDateTime: dueDateTime,
                                reminderTime: reminderTime,
                                todoNote: userData.todoNote[index],
                                RecurringStartDate: recurringStartDate,
                                RecurringEndDate: recurringEndDate,
                                completeValue: Float(userData.completeValue[index]) )
                DispatchQueue.main.async {
                    store.diets.append(diet)
                }
            } else {
                print("DietList - 日期或時間轉換失敗")
            }
        }
    }
    completion(["message":"Success"])
}

func handleRoutineList(data: Data,store: RoutineStore, completion: @escaping ([String:String]) -> Void) {
    store.clearTodos()
    handleDecodableData(RoutineData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.todoTitle.indices {
            
            if let startDate = convertToDate(userData.startDateTime[index]),
               let dueDateTime = convertToDate(userData.dueDateTime[index]),
               let recurringStartDate = convertToDate(userData.RecurringStartDate[index]),
               let recurringEndDate = convertToDate(userData.RecurringEndDate[index]),
               let routinesTime = convertToTime(userData.routinesTime[index]),
               let reminderTime = convertToTime(userData.reminderTime[index]) {
                
                let recurringOption = calculateRecurringOption(dueDateTime: dueDateTime, startDate: startDate)
                let todoStatus = userData.todoStatus[index]
                let isTodoStatus = ConvertTodoStatus(todoStatus: todoStatus ?? 0)
                
                scheduleNotificationIfNeeded(alert_time: reminderTime, title: userData.todoTitle[index], body: userData.todoIntroduction[index],tid: String(userData.todo_id[index]), isRemove: false)
                let routine = Routine(id: userData.todo_id[index],
                                      label: userData.todoLabel[index]!,
                                      title: userData.todoTitle[index],
                                      description: userData.todoIntroduction[index],
                                      startDateTime: startDate,
                                      selectedRoutines: userData.routinesType[index],
                                      routineValue: userData.routinesValue[index],
                                      routineTime: routinesTime,
                                      recurringOption: recurringOption,
                                      todoStatus: isTodoStatus,
                                      dueDateTime: dueDateTime,
                                      reminderTime: reminderTime,
                                      todoNote: userData.todoNote[index],
                                      RecurringStartDate: recurringStartDate,
                                      RecurringEndDate: recurringEndDate,
                                      sleepTime: convertToTime(userData.sleepTime[index]),
                                      wakeUpTime: convertToTime(userData.wakeUpTime[index]))
                DispatchQueue.main.async {
                    store.routines.append(routine)
                }
            } else {
                print("DietList - 日期或時間轉換失敗")
            }
        }
    }
    completion(["message":"Success"])
}

func handletickersList(data: Data,store: TickerStore, completion: @escaping ([String:String]) -> Void) {
    store.clearTodos()
    handleDecodableData(TickerData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.ticker_id.indices {
            if let deadline = convertToDateTime(userData.deadline[index]) {
                var exchange: String?
                if userData.exchange[index] == nil {
                    exchange = "尚未兌換"
                } else {
                    exchange = (userData.exchange[index]!)
                }
                let taskId = userData.ticker_id[index]
                let task = Ticker(id: taskId, name: userData.name[index], deadline: deadline, exchage: exchange!)
                
                DispatchQueue.main.async {
                    store.tickers.append(task)
                }
                
            } else {
                print("TickerList - 尚未兌換")
            }
        }
    }
    completion(["message":"Success"])
}

func handleCommunitysList(data: Data,store: CommunityStore, completion: @escaping ([String:String]) -> Void) {
    store.clearTodos()
    handleDecodableData(CommunityData.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")

        for index in userData.community_id.indices {
            
            let task = Community(id: userData.community_id[index],
                                 communityName: userData.communityName[index],
                                 communityDescription: userData.communityDescription[index],
                                 communityCategory: userData.communityCategory[index]!, image: userData.image[index], isMember: userData.isMember[index])
            DispatchQueue.main.async {
                store.communitys.append(task)
            }
        }
    }
    completion(["message":"Success"])
}
