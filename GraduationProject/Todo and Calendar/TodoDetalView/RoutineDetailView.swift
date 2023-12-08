//
//  RoutineDetailView.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/12/7.
//

import SwiftUI

struct RoutineDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routineStore: RoutineStore
    @Binding var routine: Routine
    @State private var showAlert = false
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

            Form {
                Section {
                    Text(routine.title)
                        .foregroundColor(Color.gray)
                    Text(routine.description)
                        .foregroundColor(Color.gray)
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
                        Spacer()
                        TextField("標籤", text: $routine.label)
                            .onChange(of: routine.label) { newValue in
                                routine.label = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        Text("選擇時間")
                        Spacer()
                        Text(formattedDate(routine.startDateTime))
                            .foregroundColor(Color.gray)
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
                        DatePicker("提醒時間", selection: $routine.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: routine.reminderTime) { newValue in
                                routine.reminderTime = newValue
                            }
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "bed.double.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 8)
                        
                        Text("作息目標")
                        
                        Spacer()
                        
                        if let preText = routinesPreTextByType[routine.selectedRoutines] {
                            Text(preText)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        if routine.selectedRoutines == "早睡" || routine.selectedRoutines == "早起" {
                            Text(formattedTime(routine.routineTime))
                        } else if routine.selectedRoutines == "睡眠時長" {
                            Text(String(routine.routineValue))
                        }
                        Spacer()
                        if let primaryUnits = routinesUnitsByType[routine.selectedRoutines] {
                            Text(primaryUnits.first!)
                                .font(.subheadline)
                        }
                    }
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("結束日期", selection: $routine.dueDateTime, displayedComponents: [.date])
                            .onChange(of: routine.dueDateTime) { newValue in
                                routine.dueDateTime = newValue
                            }
                    }

                }

                Section {
                    TextField("備註", text: $routine.todoNote)
                        .onChange(of: routine.todoNote) { newValue in
                            routine.todoNote = newValue
                        }
                }
               
                if(isError) {
                    Text(messenge)
                        .foregroundColor(.red)
                }
                Section {
                    // 刪除按鈕
                    Button(action: {
                        self.showAlert = true
                    }) {
                        Text("刪除")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("重要提醒："),
                            message: Text("您即將刪除此任務及其所有相關資料，包含所有習慣追蹤指標的歷史紀錄。\n請注意，此操作一旦執行將無法復原。\n您確定要繼續進行嗎？"),
                            primaryButton: .destructive(Text("確定")) {
                                // 添加刪除功能在這裡，寶貝加油
                                deleteTodo{_ in }
                            },
                            secondaryButton: .cancel(Text("取消"))
                        )
                    }
                    
                    Button(action: {
                        reviseRoutine{_ in }
                        if routine.label == "" {
                            routine.label = "notSet"
                        }
                    }) {
                        Text("完成")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationBarTitle("作息修改")
            .navigationBarItems(trailing: EmptyView())
    }
    
    func reviseRoutine(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": routine.id,
            "title": routine.title,
            "label": routine.label,
            "description": routine.description,
            "reminderTime": formattedTime(routine.reminderTime),
            "dueDateTime": formattedDate(routine.dueDateTime),
            "todoNote": routine.todoNote
        ]
        phpUrl(php: "reviseRoutine" ,type: "reviseTask",body:body, store: nil){ message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.isError = true
                    self.messenge = "習慣修改錯誤 請聯繫管理員"
                    print("修改運動回傳：\(String(describing: message["message"]))")
                }
                completion(message["message"]!)
            }
        }
    }
    
    func deleteTodo(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": routine.id,
            "type": "Routine",
        ]
        
        phpUrl(php: "deleteTodo", type: "reviseTask", body: body, store: nil) { message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.routineStore.deleteTodo(withID: self.routine.id)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.isError = true
                    self.messenge = "習慣刪除錯誤 請聯繫管理員"
                    print("刪除一般學習回傳：\(String(describing: message["message"]))")
                }
                completion(message["message"]!)
            }
        }
    }
}

struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var routine = Routine(id: 1,
                                     label: "我是標籤",
                                     title: "我要好好睡覺",
                                     description: "我要早睡",
                                     startDateTime: Date(),
                                     selectedRoutines: "早睡",
                                     routineValue: 3,
                                     routineTime: Date(),
                                     recurringOption: 2,
                                     todoStatus: false,
                                     dueDateTime: Date(),
                                     reminderTime: Date(),
                                     todoNote: "我是備註",
                                     RecurringStartDate: Date(),
                                     RecurringEndDate: Date())


        RoutineDetailView(routine: $routine)
    }
}
