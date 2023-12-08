//
//  TaskCompletionViewModel.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/14.
//

import Foundation

class TaskCompletionViewModel: ObservableObject {
    @Published var viewingMode: ViewingMode = .byTime
    @Published var selectedEventType: EventType = .generalLearning

    // Dummy data for tasks
    var tasks: [TaskInfo] = [
            TaskInfo(title: "Task 1", date: Date(), completedTasks: 3, totalTasks: 5, eventName: .generalLearning), // Changed from "事件A" to EventType
            TaskInfo(title: "Task 2", date: Date().addingTimeInterval(-86400), completedTasks: 2, totalTasks: 4, eventName: .intervalLearning) // Changed from "事件B" to EventType
        ]
    
    func completedTasks(for timeFrame: TimeFrame, date: Date) -> Int {
        // Implement your logic to filter tasks based on the selected time frame and date
        // For demo purposes, we just return the total completed tasks
        return tasks.reduce(0) { $0 + $1.completedTasks }
    }
    
    func totalTasks(for timeFrame: TimeFrame, date: Date) -> Int {
        // Implement your logic to filter tasks based on the selected time frame and date
        // For demo purposes, we just return the total tasks
        return tasks.reduce(0) { $0 + $1.totalTasks }
    }
    
    func completionPercentage(for timeFrame: TimeFrame, date: Date) -> Double {
        let completed = completedTasks(for: timeFrame, date: date)
        let total = totalTasks(for: timeFrame, date: date)
        return (total == 0) ? 0 : Double(completed) / Double(total)
    }
    
    func completionPercentageForEvent(event: EventType, date: Date) -> Double {
        // 根據事件和日期篩選任務
        let filteredTasks = tasks.filter { $0.eventName == event && isSameDay($0.date, date) }

        // 計算完成的任務和總任務
        let completedTasksCount = filteredTasks.reduce(0) { $0 + $1.completedTasks }
        let totalTasksCount = filteredTasks.reduce(0) { $0 + $1.totalTasks }

        // 計算和返回完成百分比
        return (totalTasksCount == 0) ? 0 : Double(completedTasksCount) / Double(totalTasksCount)
    }

    // 一個輔助方法來確定兩個日期是否在同一天
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    func breakdown(for timeFrame: TimeFrame, date: Date) -> [String: Double] {
        // The logic here should filter and aggregate tasks based on the selected date and time frame
        switch timeFrame {
        case .week:
            return ["星期一": 0.5, "星期二": 0.7, "星期三": 0.6, "星期四": 0.8, "星期五": 0.9, "星期六": 0.4, "星期日": 0.3]
        case .month:
            return ["第一週": 0.7, "第二週": 0.8, "第三週": 0.6, "第四週": 0.9]
        case .year:
            return ["一月": 0.8,
                    "二月": 0.7,
                    "三月": 0.9,
                    "四月": 0.6,
                    "五月": 0.7,
                    "六月": 0.8,
                    "七月": 0.9,
                    "八月": 0.8,
                    "九月": 0.7,
                    "十月": 0.6,
                    "十一月": 0.7,
                    "十二月": 0.8]
        }
    }
    
    func tasksByEvent() -> [String: Double] {
        var eventCompletionPercentages: [String: Double] = [:]
        
        let events = Set(tasks.compactMap { $0.eventName })  // 獲取所有的事件名稱
        for event in events {
            let tasksForEvent = tasks.filter { $0.eventName == event }
            let completed = tasksForEvent.reduce(0) { $0 + $1.completedTasks }
            let total = tasksForEvent.reduce(0) { $0 + $1.totalTasks }
            let percentage = (total == 0) ? 0 : Double(completed) / Double(total)
            eventCompletionPercentages[event.rawValue] = percentage
        }
        
        return eventCompletionPercentages
    }
    
    func breakdownForEvent(event: EventType, date: Date) -> [String: Double] {
            // The logic here should filter and aggregate tasks based on the selected date and event type
            // For demo purposes, we just return a static breakdown for each event
            switch event {
            case .generalLearning:
                return ["一般學習": 0.8]
            case .intervalLearning:
                return ["間隔學習": 0.7]
            case .exercise:
                return ["運動": 0.9]
            case .routine:
                return ["作息": 0.6]
            case .diet:
                return ["飲食": 0.75]
            }
        }
    func tasks(for timeFrame: TimeFrame, date: Date) -> [TaskInfo] {
        switch timeFrame {
        case .week:
            let startOfWeek = Calendar.current.startOfWeek(for: date)
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            return tasks.filter { $0.date >= startOfWeek && $0.date <= endOfWeek }
        case .month:
            let startOfMonth = Calendar.current.startOfMonth(for: date)
            let endOfMonth = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!)!
            return tasks.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
        case .year:
            let startOfYear = Calendar.current.startOfYear(for: date)
            let endOfYear = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .year, value: 1, to: startOfYear)!)!
            return tasks.filter { $0.date >= startOfYear && $0.date <= endOfYear }
        }
    }

}
