//
//  AddSleepView.swift
//  GraduationProject
//
//  Created by heonrim on 8/16/23.
//

import SwiftUI

struct AddSleepView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoStore: TodoStore
    
    @State var uid: String = ""
    @State var category_id: Int = 1
    @State var label: String = ""
    @State var todoTitle: String = ""
    @State var todoIntroduction: String = ""
    @State var startDateTime: Date = Date()
    @State var todoStatus: Bool = false
    @State var dueDateTime: Date = Date()
    @State var recurring_task_id: Int? = nil
    @State var reminderTime: Date = Date()
    @State var todoNote: String = ""
    @State var dietsType: String = ""
    @State private var showSleepsPicker = false
    @State private var selectedSleepsUnit: String = "次"
    @State private var selectedTimeUnit: String = "每日"
    @State private var sleepDuration: Date = Date()
    
    let sleeps = [
        "早睡", "早起", "睡眠時長"
    ]
    
    let sleepsUnitsByType: [String: [String]] = [
        "早睡": ["睡覺"],
        "早起": ["起床"],
        "睡眠時長": ["小時"],
    ]
    
    let sleepsPreTextByType: [String: String] = [
        "早睡": "早於",
        "早起": "早於",
        "睡眠時長": "睡滿",
    ]
    
    
    let timeUnits = ["每日", "每周", "每月"]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    @State private var selectedSleeps = "早睡"
    @State private var sleepsUnit = "每日"
    @State private var sleepsValue: Double = 0
    
    
    struct TodoData: Decodable {
        var userId: String?
        var category_id: Int
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        var reminderTime: String
        var todo_id: String
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("標題", text: $todoTitle)
                    TextField("內容", text: $todoIntroduction)
                }
                Section {
                    HStack {
                        Image(systemName: "tag.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        TextField("標籤", text: $label)
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("選擇時間", selection: $startDateTime, displayedComponents: [.date])
                    }
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("提醒時間", selection: $reminderTime, displayedComponents: [.hourAndMinute])
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "bed.double.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 8)
                        
                        Text("作息類型")
                        
                        Spacer()
                        
                        Button(action: {
                            self.showSleepsPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedSleeps)
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if showSleepsPicker {
                        Picker("作息類型", selection: $selectedSleeps) {
                            ForEach(sleeps, id: \.self) { sleep in
                                Text(sleep).tag(sleep)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    HStack(spacing: 10) {
                        Text("每日").padding(.trailing)
                        
                        if let preText = sleepsPreTextByType[selectedSleeps] {
                            Text(preText)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        if selectedSleeps == "早睡" || selectedSleeps == "早起" {
                            DatePicker("選擇時間", selection: $sleepDuration, displayedComponents: [.hourAndMinute])
                                .labelsHidden()
                        } else if selectedSleeps == "睡眠時長" {
                            TextField("輸入數值", value: $sleepsValue, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .frame(width: 80, alignment: .center)
                        }
                        
                        if let primaryUnits = sleepsUnitsByType[selectedSleeps] {
                            Text(primaryUnits.first!)
                                .font(.subheadline)
                        }
                        
                    }
                    .padding(.horizontal)
                }
                
                Section {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        
                        Picker("週期", selection: $recurringOption) {
                            Text("一直重複").tag(1)
                            Text("週期結束時間").tag(2)
                        }
                    }
                    
                    if recurringOption == 2 {
                        DatePicker("結束重複日期", selection: $recurringEndDate, displayedComponents: [.date])
                    }
                }
                TextField("備註", text: $todoNote)
            }
            .navigationBarTitle("作息")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成", action: addTodo))
        }
        .onAppear {
            sleepsUnit = sleepsUnitsByType["早睡"]!.first!
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter.string(from: date)
    }
    
    func addTodo() {
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
        
        let url = URL(string: "http://172.20.10.3:8888/addTodo.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["category_id": category_id,
                    "label": label,
                    "todoTitle": todoTitle,
                    "todoIntroduction": todoIntroduction,
                    "startDateTime": formattedDate(startDateTime),
                    "todoStatus": todoStatus,
                    "dueDateTime": formattedDate(dueDateTime),
                    "recurring_task_id": recurring_task_id ?? "",
                    "reminderTime": formattedTime(reminderTime),
                    "todoNote": todoNote] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("addTodo - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("addTodo - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User New Todo successfully") {
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("addTodo - message：\(todoData.message)")
                    }
                } catch {
                    print("addTodo - 解碼失敗：\(error)")
                }
            }
        }
        .resume()
    }
}

struct AddSleepView_Previews: PreviewProvider {
    static var previews: some View {
        AddSleepView()
    }
}
