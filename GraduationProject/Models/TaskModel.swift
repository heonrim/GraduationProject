//
//  TaskModel.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/10.
//

import Foundation
import SwiftUI

enum TaskType: String {
    case sport, space, study, diet, sleep
}

class DailyTask: ObservableObject {
    var id: Int
    var name: String
    var type: TaskType
    @Published var isCompleted: Bool = false
    @Published var isSuccess: Bool? = nil
    @Published var completedValue: Float = 0.0
    var targetValue: Float = 0.0
    var targetTime: Date?
    @Published var animationPlayed: Bool = false
    
    func formattedTargetTime() -> String? {
        guard let targetTime = targetTime else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: targetTime)
    }
    
    init(id: Int, name: String, type: TaskType, isCompleted: Bool = false, targetValue: Float, targetTime: Date? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.isCompleted = isCompleted
        self.targetValue = targetValue
        self.targetTime = targetTime
    }
}

class TodayTodoData: ObservableObject {
    @Published var tasks: [DailyTask] = TaskService.shared.getTasks()
    
    func updateTask(_ task: DailyTask) {
        TaskService.shared.updateTask(task)
        // Refresh the tasks list after updating
        tasks = TaskService.shared.getTasks()
    }
}

enum ViewingMode: String, CaseIterable {
    case byTime = "依照時間"
    case byEvent = "依照事件"
}

enum EventType: String, CaseIterable {
    case generalLearning = "一般學習"
    case intervalLearning = "間隔學習"
    case exercise = "運動"
    case routine = "作息"
    case diet = "飲食"
}

struct TaskInfo: Identifiable {
    var id = UUID()  // Add this line
    var title: String
    var date: Date
    var completedTasks: Int
    var totalTasks: Int
    var eventName: EventType
}
