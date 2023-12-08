//
//  PHPUrl.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/9/28.
//

import Foundation

//var server = "http://127.0.0.1:8888"
var server = "http://163.17.136.73:443"
//var server = "http://172.20.10.8:8888"

class URLSessionSingleton {
    static let shared = URLSessionSingleton()
    let session: URLSession
    private init() {
        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        config.httpCookieAcceptPolicy = .always
        session = URLSession(configuration: config)
    }
}

func phpUrl(php: String,type: String,body: [String:Any],store: (any ObservableObject)? = nil, completion: @escaping ([String:String]) -> Void) {
    var url: URL?
    url = URL(string: "\(server)/\(type)/\(php).php")
    print("新的url\(String(describing: url))")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])

    request.httpBody = jsonData
    
    URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("\(php) - Connection error: \(error)")
        }else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("StudySpaceList - HTTP error: \(httpResponse.statusCode)")
        }else if let data = data {
            handleDataForPHP(php: php, data: data, store: store) { message in
                completion(message) // 调用回调闭包传递 message
            }
        }
    }.resume()
}

func convertToDate(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
//    dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
//    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: dateString)
}

func convertToTime(_ timeString: String?) -> Date? {
    print("希望成功轉過去\(timeString)")
    print("希望成功轉過去\(String(describing: timeString))")
    guard let timeString = timeString else { return nil }
    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
//    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "HH:mm:ss"
//        dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.date(from: timeString)
}
func convertToTimeM(_ timeString: String?) -> Date? {
    guard let timeString = timeString else { return nil }
    
    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
    //    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.date(from: timeString)
}
func convertToTimeHR(_ timeString: String?) -> Date? {
    guard let timeString = timeString else { return nil }
    
    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.date(from: timeString)
}

func convertToDateTime(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.date(from: dateString)
}

func convertToTaipeiTime(_ date: Date) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // Convert the Date to String
    let dateString = dateFormatter.string(from: date)
    
    // Then, parse the String back to Date
    return dateFormatter.date(from: dateString)
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    //    formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
    formatter.locale = Locale(identifier: "zh_Hant_TW") // 設定為台灣地區
    formatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定為台北時區
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_Hant_TW") // 設定為台灣地區
    formatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定為台北時區
    //    formatter.dateFormat = "HH:mm:ss"
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

extension DateFormatter {
    static let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "YYYY年M月d日"
        return formatter
    }()
    
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        formatter.dateFormat = "YYYY年MM月"
        return formatter
    }()
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年"
        return formatter
    }()
}

func handleDataForPHP(php: String, data: Data,store: (any ObservableObject)? = nil, completion: @escaping ([String:String]) -> Void) {
    switch php {
    case "login":
        handleLogin(data: data, completion: completion)
    case "register":
        handleRegister(data: data, completion: completion)
        
    case "StudySpaceList":
        handleStudySpaceList(data: data,store: store as! TaskStore, completion: completion)
    case "StudyGeneralList":
        handleStudyGeneralList(data: data,store: store as! TodoStore, completion: completion)
    case "SportList":
        handleSportList(data: data,store: store as! SportStore, completion: completion)
    case "DietList":
        handleDietList(data: data,store: store as! DietStore, completion: completion)
    case "RoutineList":
        handleRoutineList(data: data,store: store as! RoutineStore, completion: completion)
    case "tickersList":
        handletickersList(data: data,store: store as! TickerStore, completion: completion)
    case "CommunityList":
        handleCommunitysList(data: data,store: store as! CommunityStore, completion: completion)
        
    case "addStudySpaced":
        handleStudySpaceAdd(data: data,store: store as! TaskStore, completion: completion)
    case "addStudyGeneral":
        handleStudyGeneralAdd(data: data,store: store as! TodoStore, completion: completion)
    case "addSport":
        handleSportAdd(data: data,store: store as! SportStore, completion: completion)
    case "addDiet":
        handleDietAdd(data: data,store: store as! DietStore, completion: completion)
    case "addRoutine":
        handleRoutineAdd(data: data,store: store as! RoutineStore, completion: completion)
    case "addCommunity":
        handleCommunityAdd(data: data,store: store as! CommunityStore, completion: completion)
    case "autoAdd":
        handleAutoAdd(data: data, completion: completion)
        
    case "deleteTodo":
        handleDeleteTodo(data: data, completion: completion)
    case "reviseSpace":
        handleStudySpaceRevise(data: data, completion: completion)
    case "reviseStudy","reviseSport","reviseDiet":
        handleGeneralRevise(data: data, completion: completion)
    case "reviseProfile":
        handleReviseProfile(data: data, completion: completion)
        
    case "upDateCompleteValue":
        handleUpDateCompleteValue(data: data, completion: completion)
    case "upDateSpaced":
        handleUpDateCompleteValue(data: data, completion: completion)
        
    case "TrackingFirstDay":
        handleTrackingFirstDay(data: data, messageType: .TrackingFirstDay, completion: completion)
    case "RecurringCheckList":
        handleRecurringCheckList(data: data,store: store as! CompletionRatesViewModel, messageType: .RecurringCheckList, completion: completion)
        
    default:
        break
    }
}

func handleDecodableData<T: Decodable>(_ type: T.Type, data: Data, handler: (T) -> Void) {
    do {
        let decoder = JSONDecoder()
        let userData = try decoder.decode(type, from: data)
        print("============== \(type) ============== \(type) ==============")
        print("\(type): \(String(data: data, encoding: .utf8)!)")
        handler(userData)
        print("============== \(type) ============== \(type) ==============")
    } catch {
        print("解碼失敗：\(error)")
        print("\(type): \(String(data: data, encoding: .utf8)!)")
    }
}
