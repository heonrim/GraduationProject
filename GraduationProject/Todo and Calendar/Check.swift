//
//  Check.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/10/18.
//

import Foundation

func TrackingFirstDay(id: Int, completion: @escaping (Date, Int) -> Void) {
    let body = ["id": id] as [String : Any]
    print("TrackingFirstDay body:\(body)")
    phpUrl(php: "TrackingFirstDay" ,type: "Tracking",body:body,store: nil) { message in
        for (key, value) in message {
            if let selectedDate = convertToDate(key), let Instance_id = Int(value) {
                completion(selectedDate, Instance_id)
            }
            
        }
    }
}


func RecurringCheckList(id: Int,targetvalue:Float,store:(any ObservableObject)? = nil,completion: @escaping ([String:String]) -> Void) {
    let body = ["id": id,"targetvalue": targetvalue] as [String : Any]
    print("RecurringCheckList body:\(body)")
    phpUrl(php: "RecurringCheckList", type: "Tracking", body: body, store: store) { message in
        completion(message)
    }
}

func handleTrackingFirstDay(data: Data, messageType: Message, completion: @escaping ([String:String]) -> Void) {
    handleDecodableData(FirstDay.self, data: data) { userData in
        print("\(userData.message) - userDate:\(userData)")
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            print("\(messageType.rawValue) - userDate:\(userData)")
            let selectedDate = userData.RecurringStartDate
            let Instance_id = String(userData.id)
            completion([selectedDate:Instance_id])
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message":userData.message])
            print("\(messageType.rawValue) - Message：\(userData.message)")
        }
    }
}

func handleRecurringCheckList(data: Data,store: CompletionRatesViewModel, messageType: Message, completion: @escaping ([String: String]) -> Void) {
    handleDecodableData(CheckList.self, data: data) { userData in
        print("\(messageType.rawValue) - userDate:\(userData)")
        if userData.message == messageType.rawValue {
            print("============== \(messageType.rawValue) ==============")
            store.clearTodos()
            var dictionary1: [String: Double] = [:]
            var dictionary2: [String: Double] = [:]
            
            //            let completeValue = userData.completeValue.compactMap { (Double($0) )/(Double(userData.targetvalue) ) }
                        let completeValue = userData.completeValue.compactMap { (Double($0) )/(Double(userData.targetvalue) ) }.map { $0 > 1 ? 1 : $0 }
            let checkDate = userData.checkDate.compactMap { $0 }
            // 使用 zip 将两个数组合并成元组的数组
            if completeValue.count == checkDate.count {
                // 使用 zip 函数将两个数组合并为元组数组

                let combinedArray1 = Array(zip(checkDate, completeValue))
                // 使用 Dictionary(uniqueKeysWithValues:) 创建字典
                dictionary1 = Dictionary(combinedArray1, uniquingKeysWith: { (current, new) in
//                    current + new
                    let sum = current + new
                    return sum > 1 ? 1 : sum
                })
            } else {
                print("两个数组的元素数量不一致")
            }
            
            let monthlyCompleteValue = userData.monthlyCompleteValue.compactMap { Double($0) }
            let monthlyCount = userData.monthlyCount.compactMap { Double($0) }
            let yearsMonth = userData.yearsMonth.compactMap { $0 }
            
            if monthlyCompleteValue.count == yearsMonth.count {
                let averageValues = zip(monthlyCompleteValue, monthlyCount)
//                       .map { $0 / $1 / Double(userData.targetvalue) }
                    .map { min($0 / $1 / Double(userData.targetvalue), 1.0) } // 確保不超過1

                   
                   if averageValues.count == yearsMonth.count {
                       let combinedArray2 = Array(zip(yearsMonth, averageValues))
                       dictionary2 = Dictionary(uniqueKeysWithValues: combinedArray2)
                       // 使用 combinedDictionary
                   } else {
                       print("兩個陣列的元素數量不一致")
                   }
            } else {
                print("两个数组的元素数量不一致")
            }
            store.completionRates = dictionary1.merging(dictionary2) { (current, new) in current + new }
            print("============== \(messageType.rawValue) ==============")
        } else {
            completion(["message": userData.message])
        }
    }
}
