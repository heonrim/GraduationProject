//
//  TaskService.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/10.
//

import Foundation

class TaskService: ObservableObject {
    static let shared = TaskService()

    @Published var tasks: [DailyTask]

    private var mockTasks: [DailyTask] = [
        DailyTask(id: 1, name: "跑步", type: .sport, targetValue: 10.0),
        DailyTask(id: 2, name: "學習", type: .study, targetValue: 5.0),
        DailyTask(id: 3, name: "第一次複習", type: .space, targetValue: 1.0),
        DailyTask(id: 4, name: "減糖", type: .diet, targetValue: 3.0),
        DailyTask(id: 5, name: "早睡", type: .sleep, targetValue: 3.0, targetTime: Calendar.current.date(from: DateComponents(hour: 22, minute: 0)))
    ]

    private init() {
        tasks = mockTasks
    }

    func getTasks() -> [DailyTask] {
        return tasks
    }

    func updateTask(_ task: DailyTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            print("Error: Task with id \(task.id) not found.")
        }
    }
}
