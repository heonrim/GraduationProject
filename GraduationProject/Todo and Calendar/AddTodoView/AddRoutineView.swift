//
//  AddroutineView.swift
//  GraduationProject
//
//  Created by heonrim on 8/16/23.
//

import SwiftUI

struct AddRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routineStore: RoutineStore
    
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
    @State private var showRoutinesPicker = false
    
    @State private var routineDuration: Date = Date()
    
    let routinesType = [
        "早睡", "早起", "睡眠時長"
    ]
    
    let routinesUnitsByType: [String: [String]] = [
        "早睡": ["睡覺"],
        "早起": ["起床"],
        "睡眠時長": ["小時"],
    ]
    
    let routinesPreTextByType: [String: String] = [
        "早睡": "早於",
        "早起": "早於",
        "睡眠時長": "睡滿",
    ]
    
    
    let timeUnits = ["每日", "每周", "每月"]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    @State private var selectedRoutines = "早睡"
    @State private var routinesUnit = "每日"
    @State private var routinesValue: Double = 0
    @State var messenge = ""
    @State var isError = false
    
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
                        self.showRoutinesPicker.toggle()
                    }) {
                        HStack {
                            Text(selectedRoutines)
                                .foregroundColor(.black)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                if showRoutinesPicker {
                    Picker("作息類型", selection: $selectedRoutines) {
                        ForEach(routinesType, id: \.self) { routine in
                            Text(routine).tag(routine)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                HStack(spacing: 10) {
                    Text("每日").padding(.trailing)
                    
                    if let preText = routinesPreTextByType[selectedRoutines] {
                        Text(preText)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    if selectedRoutines == "早睡" || selectedRoutines == "早起" {
                        DatePicker("選擇時間", selection: $routineDuration, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                    } else if selectedRoutines == "睡眠時長" {
                        TextField("輸入數值", value: $routinesValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 80, alignment: .center)
                    }
                    
                    if let primaryUnits = routinesUnitsByType[selectedRoutines] {
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
            Section {
                TextField("備註", text: $todoNote)
            }
            
            if(isError) {
                Text(messenge)
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitle("作息")
        .navigationBarItems(leading:
                                Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("返回")
                .foregroundColor(.blue)
        },
                            trailing: Button("完成"){
            
            
            if routineStore.checkForSelectedRoutine(named: selectedRoutines) {
                print("存在'早起'的Routine")
                isError = true
                messenge = "不可重複建立同類型作息習慣"
            } else {
                print("不存在'早起'的Routine")
                addRoutine {_ in }
            }
            
        }
            .disabled(todoTitle.isEmpty && todoIntroduction.isEmpty))
        .onAppear {
            routinesUnit = routinesUnitsByType["早睡"]!.first!
        }
    }
}
    
    func addRoutine(completion: @escaping (String) -> Void) {
        var body = ["label": label,
                    "todoTitle": todoTitle,
                    "todoIntroduction": todoIntroduction,
                    "startDateTime": formattedDate(startDateTime),
                    "routineType": selectedRoutines,
                    "routineValue": routinesValue,
                    "routineTime": formattedTime(routineDuration),
                    "reminderTime": formattedTime(reminderTime),
                    "todoNote": todoNote] as [String : Any]
        if recurringOption == 1 {
            // 持續重複
            body["dueDateTime"] = formattedDate(Calendar.current.date(byAdding: .year, value: 5, to: recurringEndDate)!)
        } else {
            body["dueDateTime"] = formattedDate(recurringEndDate)
        }
        print("addRoutine:\(body)")
        phpUrl(php: "addRoutine" ,type: "addTask",body:body,store: routineStore){ message in
            print("建立作息回傳：\(String(describing: message["message"]))")
            if message["message"] == "The Todo is repeated" {
                isError = true
                messenge = "不可重複輸入目前正在執行的習慣"
            } else if message["message"] == "Success" {
                isError = false
                messenge = ""
                presentationMode.wrappedValue.dismiss()
            } else {
                isError = true
                messenge = "習慣建立錯誤 請聯繫管理員"
            }
            completion(message["message"]!)
        }
    }
}
struct AddRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutineView()
    }
}
