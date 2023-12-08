//
//  TimeExtensions.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/14.
//

import Foundation

enum TimeFrame: String, CaseIterable {
    case week = "週指標"
    case month = "月指標"
    case year = "年指標"
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
    
    func startOfMonth(for date: Date) -> Date {
        let components = self.dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
    
    func startOfYear(for date: Date) -> Date {
        let components = self.dateComponents([.year], from: date)
        return self.date(from: components)!
    }
}
