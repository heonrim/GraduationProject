//
//  TodoManager.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import Foundation

enum Action: Int, Identifiable {
    var id: Int { rawValue }
    
    case generalLearning = 1
    case spacedLearning
    case sport
    case routine
    case diet
}
struct UserData: Decodable {
    var id: Int?
    var email: String?
    var userName: String?
    var userDescription: String?
    var currentStep: Int?
    var create_at: String?
    var image: String?
    var message: String
}
struct ReviseData: Decodable {
    var todo_id: Int
    var todoTitle: String
    var label: String
    var reminderTime: String
    var todoIntroduction: String
    var dueDateTime: String?
    var todoNote: String?
    var message: String
}
struct DeleteData: Decodable {
    var todo_id: Int
    var message: String
}
struct UpdateValueData: Decodable {
    var todo_id: Int
    var status: String?
    var RecurringStartDate: String?
    var RecurringEndDate: String?
    var completeValue: Float?
    var message: String
}

struct TaskData: Decodable {
    var todo_id: [Int]    
    var userId: Int?
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    var reminderTime: [String]
    var repetition1Status: [Int?]
    var repetition2Status: [Int?]
    var repetition3Status: [Int?]
    var repetition4Status: [Int?]
    var repetition1Count: [String]
    var repetition2Count: [String]
    var repetition3Count: [String]
    var repetition4Count: [String]
    var todoStatus: [Int]
    var message: String
}

struct TodoData: Decodable {
    var userId: Int?
    var todo_id: [Int]
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var studyValue: [String]
    var studyUnit: [Int]
    
    var frequency: [Int]
    var reminderTime: [String]
    var todoStatus: [Int?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var completeValue: [Int]
    
    var message: String
}

struct SportData: Decodable {
    var userId: Int?
    var todo_id: [Int]
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var sportType: [String]
    var sportValue: [String]
    var sportUnit: [Int]
    
    var frequency: [Int]
    var reminderTime: [String]
    var todoStatus: [Int?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var completeValue: [Int]
    
    var message: String
}

struct DietData: Decodable {
    var userId: Int?
    var todo_id: [Int]
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var dietsType: [String]
    var dietsValue: [Int]
    
    var frequency: [Int]
    var reminderTime: [String]
    var todoStatus: [Int?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var completeValue: [Int]
    
    var message: String
}
struct RoutineData: Decodable {
    var userId: Int?
    var todo_id: [Int]
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String?]
    var startDateTime: [String]
    
    var routinesType: [String]
    var routinesValue: [Int]
    var routinesTime: [String]
    
//    var frequency: [Int]
    var reminderTime: [String]
    var todoStatus: [Int?]
    var dueDateTime: [String]
    var todoNote: [String]
    
    var RecurringStartDate: [String]
    var RecurringEndDate: [String]
    var sleepTime: [String?]
    var wakeUpTime: [String?]
//    var completeValue: [Int]
    
    var message: String
}

struct TickerData: Decodable {
    var userId: Int?
    var ticker_id: [String]
    var name: [String]
    var deadline: [String]
    var exchange: [String?]
    var message: String
}

struct CommunityData: Decodable {
    var userId: String?
    var community_id: [Int]
    var communityName: [String]
    var communityDescription: [String]
    var communityCategory: [Int?]
    var image: [String]
    var isMember: [String]
    var message: String
}

struct addTaskData : Decodable {
    var userId: Int?
    //        var id: Int
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    var reminderTime: String
    var todo_id: Int
    var repetition1Count: String
    var repetition2Count: String
    var repetition3Count: String
    var repetition4Count: String
    
    var message: String
}
struct addTodoData : Decodable {
    var userId: Int?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var studyValue: Float
    var studyUnit: Int
    
    var frequency: Int
    var todoStatus: Int
    var reminderTime: String
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}
struct addSportData : Decodable {
    var userId: Int?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var sportType: String
    var sportValue: Float
    var sportUnit: Int
    
    var frequency: Int
    var todoStatus: Int
    var reminderTime: String
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}
struct addDietData: Decodable {
    var userId: Int?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var dietType: String
    var dietValue: Int
    
    var todoStatus: Int
    var reminderTime: String
    var frequency: Int
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}

struct addRoutineData: Decodable {
    var userId: Int?
    var category_id: Int
    var todoLabel: String?
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: String
    
    var routineType: String
    var routineValue: Int
    var routineTime: String
    
    var reminderTime: String
    var todoStatus: Int
    
//    var frequency: Int
    var dueDateTime: String
    var todo_id: Int
    var todoNote: String?
    var message: String
}

struct addCommunityData: Decodable {
    var community_id: Int
    var communityName: String
    var communityDescription: String
    var communityCategory: Int
    var image: String
    var message: String
}
struct autoAddData: Decodable {
    var message: String
}
struct FirstDay: Decodable {
    var id: Int
    var todo_id: Int
    var RecurringStartDate: String
    var message: String
}

struct CheckList: Decodable {
    var checkDate: [String]
    var completeValue: [Float]
    var yearsMonth: [String]
    var monthlyCount: [String]
    var monthlyCompleteValue: [Float]
    var targetvalue: Float
    var message: String
}

class CompletionRatesViewModel: ObservableObject {
    @Published var completionRates: [String: Double] = ["": 0.0]
    
    func updateCompletionRate(date: Date, newValue: Double) {
        let formattedDate = GraduationProject.formattedDate(date)
        completionRates.updateValue(newValue, forKey: formattedDate)
    }
    func clearTodos() {
        completionRates = ["": 0.0]
    }
}

class TodoStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var todos: [Todo] = []
    static let shared = TodoStore()
    func todosForDate(_ date: Date) -> [Todo] {
        let filteredTodos = todos.filter { todo in
            return isDate(date, inRangeOf: todo.startDateTime, and: todo.dueDateTime, description: todo.description)
        }
        return filteredTodos
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date, description: String) -> Bool {
        return date >= startDate && date <= endDate
        || Calendar.current.isDate(date, inSameDayAs: startDate)
        || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        todos = []
    }
    func updateCompleteValue(withID id: Int, newValue: Float) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].completeValue = newValue
        }
    }
    func deleteTodo(withID id: Int) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
        }
    }

}


class TaskStore: ObservableObject {
    // 具有一個已發佈的 tasks 屬性，該屬性存儲任務的數組
    @Published var tasks: [Task] = []
    static let shared = TaskStore()
    // 根據日期返回相應的任務列表
    func tasksForDate(_ date: Date) -> [Task] {
        let formattedSelectedDate = formattedDate(date)
        let filteredTasks = tasks.filter { task in
            return formattedSelectedDate == formattedDate(task.nextReviewDate) ||
            formattedSelectedDate == formattedDate(task.repetition1Count) ||
            formattedSelectedDate == formattedDate(task.repetition2Count) ||
            formattedSelectedDate == formattedDate(task.repetition3Count) ||
            formattedSelectedDate == formattedDate(task.repetition4Count)
        }
        return filteredTasks
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTasks() {
        tasks = []
        }
    struct Repetition {
        var date: Date
        var isChecked: Bool
    }
    
    func deleteTodo(withID id: Int) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
        }
    }

    func updateCompleteValue(withID id: Int) {
        
        let today = formattedDate(Date())
        
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            var taskToUpdate = tasks[index]

                 let repetitions = [
                     Repetition(date: taskToUpdate.repetition1Count, isChecked: taskToUpdate.isReviewChecked0),
                     Repetition(date: taskToUpdate.repetition2Count, isChecked: taskToUpdate.isReviewChecked1),
                     Repetition(date: taskToUpdate.repetition3Count, isChecked: taskToUpdate.isReviewChecked2),
                     Repetition(date: taskToUpdate.repetition4Count, isChecked: taskToUpdate.isReviewChecked3)
                 ]

                 for (index, repetition) in repetitions.enumerated() {
                     if today == formattedDate(repetition.date) {
                         switch index {
                         case 0:
                             taskToUpdate.isReviewChecked0 = true
                         case 1:
                             taskToUpdate.isReviewChecked1 = true
                         case 2:
                             taskToUpdate.isReviewChecked2 = true
                         case 3:
                             taskToUpdate.isReviewChecked3 = true
                         default:
                             break
                         }
                         break
                     }
                 }

                 // 更新 tasks 陣列中的 Task
                 tasks[index] = taskToUpdate
        }
    }

}

class SportStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var sports: [Sport] = []
    static let shared = SportStore()
    func sportsForDate(_ date: Date) -> [Sport] {
        let filteredTodos = sports.filter { todo in
            return isDate(date, inRangeOf: todo.startDateTime, and: todo.dueDateTime)
        }
        return filteredTodos
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
        || Calendar.current.isDate(date, inSameDayAs: startDate)
        || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        sports = []
    }
    func updateSport(withID id: Int, newValue: Float) {
        if let index = sports.firstIndex(where: { $0.id == id }) {
            sports[index].completeValue = newValue
        }
    }
    func deleteTodo(withID id: Int) {
        if let index = sports.firstIndex(where: { $0.id == id }) {
            sports.remove(at: index)
        }
    }

}

class DietStore: ObservableObject {
    @Published var diets: [Diet] = []
    static let shared = DietStore()
    func dietForDate(_ date: Date) -> [Diet] {
        let filteredDiets = diets.filter { diet in
            return isDate(date, inRangeOf: diet.startDateTime, and: diet.dueDateTime)
        }
        return filteredDiets
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
        || Calendar.current.isDate(date, inSameDayAs: startDate)
        || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        diets = []
    }
    func updateCompleteValue(withID id: Int, newValue: Int) {
        if let index = diets.firstIndex(where: { $0.id == id }) {
            diets[index].completeValue = Float(newValue)
        }
    }
    func deleteTodo(withID id: Int) {
        if let index = diets.firstIndex(where: { $0.id == id }) {
            diets.remove(at: index)
        }
    }

}

class RoutineStore: ObservableObject {
    @Published var routines: [Routine] = []
    static let shared = RoutineStore()
    func routineForDate(_ date: Date) -> [Routine] {
        let filteredDiets = routines.filter { routine in
            return isDate(date, inRangeOf: routine.startDateTime, and: routine.dueDateTime)
        }
        return filteredDiets
    }
    
    func isDate(_ date: Date, inRangeOf startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
        || Calendar.current.isDate(date, inSameDayAs: startDate)
        || Calendar.current.isDate(date, inSameDayAs: endDate)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        routines = []
    }
    func checkForSelectedRoutine(named routineName: String) -> Bool {
                return routines.contains { $0.selectedRoutines == routineName }
            }
    func updateCompleteValue(withID id: Int, newValue: Date,type: Int) {
        if let index = routines.firstIndex(where: { $0.id == id }) {
            if type == 0 {
                routines[index].sleepTime = newValue
            } else if type == 1{
                routines[index].wakeUpTime = newValue
            }
            print("我是檢查 newValue ： \(newValue)")
            print("我是檢查 type ： \(type)")
            print("我是檢查 routines[index] ： \(routines[index])")
        }
    }
    func updateRecurring(withID id: Int, newDate: Date?, newTime: Date?,type: Int) {
        if let index = routines.firstIndex(where: { $0.id == id }) {
            if type == 0 {
                // 早睡
                routines[index].sleepTime = newTime
            } else if type == 1 {
                // 早起
                routines[index].wakeUpTime = newTime
            } else if type == 2 {
                // 睡眠時長 - 睡覺
                routines[index].RecurringStartDate = newDate ?? Date()
                let currentDate = Date() // 假设这是你要操作的日期
                let calendar = Calendar.current // 使用当前用户的日历
                if let nextDate = calendar.date(byAdding: .day, value: 0, to: newDate ?? Date()) {
                    print(nextDate) // nextDate 是一个 Date 对象，已经加上了一天
                    routines[index].RecurringEndDate = nextDate
                }
                routines[index].sleepTime = newTime ?? nil
                routines[index].wakeUpTime = nil
            } else if type == 3 {
                // 睡眠時長 - 起來
                routines[index].wakeUpTime = newTime
                updateOrCreateRoutineFromID(id, to: 0)

                routines[index].sleepTime = nil
                routines[index].wakeUpTime = nil
            }
            print("我是檢查 routines[index] ： \(routines[index])")
        }
    }

    func updateOrCreateRoutineFromID(_ sourceID: Int, to targetID: Int) {
        guard let sourceIndex = routines.firstIndex(where: { $0.id == sourceID }) else {
            print("錯誤：找不到源 ID \(sourceID) 的 Routine。")
            return
        }

        if let targetIndex = routines.firstIndex(where: { $0.id == targetID }) {
            var newRoutine = routines[sourceIndex]
            newRoutine.id = targetID // 確保目標 ID 保持不變
            if  routines[targetIndex].title != "\(routines[sourceIndex].title)" {
                newRoutine.title = "\(routines[sourceIndex].title) - yesterday"
            }
            routines[targetIndex] = newRoutine
        } else {
            var newRoutine = routines[sourceIndex]
            newRoutine.id = targetID // 為新 Routine 設置目標 ID
            newRoutine.title = "\(routines[sourceIndex].title) - yesterday"
            routines.append(newRoutine)
            if (routines[sourceIndex].sleepTime != nil && routines[sourceIndex].wakeUpTime != nil) {
                routines[sourceIndex].sleepTime = nil
                routines[sourceIndex].wakeUpTime = nil
            }
        }
    }
    func deleteTodo(withID id: Int) {
        if let index = routines.firstIndex(where: { $0.id == id }) {
            routines.remove(at: index)
        }
    }

}

class TickerStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var tickers: [Ticker] = []
    
    func tickersForDate(_ date: Date) -> [Ticker] {
        let formattedSelectedDate = formattedDate(date)
        let filteredTickers = tickers.filter { ticker in
            return formattedSelectedDate == formattedDate(ticker.deadline)
        }
        return filteredTickers
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTodos() {
        tickers = []
    }
}

class CommunityStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var communitys: [Community] = []
    
    func communitysIsMember() -> [Community] {
        let filteredCommunity = communitys.filter { community in
            return (community.isMember == "true" )
        }
        return filteredCommunity
    }
    func communitysNotJoined() -> [Community] {
        let filteredCommunity = communitys.filter { community in
            return (community.isMember == "false" )
        }
        return filteredCommunity
    }
    func clearTodos() {
        communitys = []
    }
}
