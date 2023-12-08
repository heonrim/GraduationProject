//
//  TodoModels.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import Foundation
import SwiftUI

struct Task: Identifiable {
    // 以下是他的屬性
    var id: Int
    var label: String
    var title: String
    var description: String
    var nextReviewDate: Date
    var nextReviewTime: Date
    var repetition1Count: Date
    var repetition2Count: Date
    var repetition3Count: Date
    var repetition4Count: Date
    var isReviewChecked0: Bool
    var isReviewChecked1: Bool
    var isReviewChecked2: Bool
    var isReviewChecked3: Bool
}


struct Todo: Identifiable {
//    var id: ObjectIdentifier
    
    var id: Int
    var label: String
    var title: String
    var description: String
    var startDateTime: Date
    
    var studyValue: Float
    var studyUnit: String
    
    // 週期選擇
    var recurringUnit: String
    // 是否有結束日期
    var recurringOption: Int
    var todoStatus: Bool
    var dueDateTime: Date
    var reminderTime: Date
    var todoNote: String
    
    var RecurringStartDate: Date
    var RecurringEndDate: Date
    var completeValue: Float
}

struct Sport: Identifiable {
    var id: Int
    var label: String
    var title: String
    var description: String
    var startDateTime: Date
    
    var selectedSport: String
    var sportValue: Float
    var sportUnits: String
    
    // 週期選擇
    var recurringUnit: String
    // 是否有結束日期
    var recurringOption: Int
    var todoStatus: Bool
    var dueDateTime: Date
    var reminderTime: Date
    var todoNote: String
    
    var RecurringStartDate: Date
    var RecurringEndDate: Date
    var completeValue: Float

}

struct Diet: Identifiable {
    var id: Int
    var label: String
    var title: String
    var description: String
    var startDateTime: Date
    
    var selectedDiets: String
    var dietsValue: Int
    
    // 週期選擇
    var recurringUnit: String
    // 是否有結束日期
    var recurringOption: Int
    var todoStatus: Bool
    var dueDateTime: Date
    var reminderTime: Date
    var todoNote: String
    
    var RecurringStartDate: Date
    var RecurringEndDate: Date
    var completeValue: Float
}

//struct Sleep: Identifiable {
//    var id: Int
//    var label: String
//    var title: String
//    var description: String
//
//    var bedtime: Date // 睡覺時間
//    var wakeTime: Date // 起床時間
//    var mode: SleepMode
//    var sleepGoalHours: Double? // 如果選擇了「睡滿N小時」模式，這將是目標小時數
//    var reminderTime: Date
//    var sleepNote: String
//}
//
//enum SleepMode: String, CaseIterable {
//    case earlyToBed = "早睡"
//    case earlyToRise = "早起"
//    case sleepFullHours = "睡滿N小時"
//}

struct Routine: Identifiable {
    var id: Int
    var label: String
    var title: String
    var description: String
    var startDateTime: Date
    
    var selectedRoutines: String
    var routineValue: Int
    var routineTime: Date
    // 週期選擇
//    var recurringUnit: String
    // 是否有結束日期
    var recurringOption: Int
    var todoStatus: Bool
    var dueDateTime: Date
    var reminderTime: Date
    var todoNote: String
    
    var RecurringStartDate: Date
    var RecurringEndDate: Date
    var sleepTime: Date?
    var wakeUpTime: Date?
//    var completeValue: Float
}

struct Ticker: Identifiable {
    var id: String
//    var ticker_id: String
    var name: String
    var deadline: Date
//    var exchage: Date
    var exchage: String
}

struct Community: Identifiable {
    var id: Int
//    var ticker_id: String
    var communityName: String
    var communityDescription: String
    var communityCategory: Int
    var image: String
    var isMember: String
}

extension Color {
    init(hex: Int) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}
