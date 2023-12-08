//
//  AddDietView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct DietDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dietStore: DietStore
    @Binding var diet: Diet
    @State private var showAlert = false
    
    let diets = [
        "減糖", "多喝水", "少油炸", "多吃蔬果"
    ]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false
    
    let dietsUnitsByType: [String: [String]] = [
        "減糖": ["次"],
        "多喝水": ["豪升"],
        "少油炸": ["次"],
        "多吃蔬果": ["份"]
    ]
    
    let dietsPreTextByType: [String: String] = [
        "減糖": "少於",
        "多喝水": "至少",
        "少油炸": "少於",
        "多吃蔬果": "至少"
    ]
    
    struct TodoData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var dueDateTime: String
        var todoNote: String
        var message: String
    }
    
    var body: some View {
            Form {
                Section {
                    Text(diet.title)
                        .foregroundColor(Color.gray)
                    Text(diet.description)
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
                        TextField("標籤", text: $diet.label)
                            .onChange(of: diet.label) { newValue in
                                diet.label = newValue
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
                        Text(formattedDate(diet.startDateTime))
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
                        DatePicker("提醒時間", selection: $diet.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: diet.reminderTime) { newValue in
                                diet.reminderTime = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        Text("目標")
                        Spacer()
                        Text(diet.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(diet.selectedDiets)
                            .foregroundColor(Color.gray)
                        
                        if let preText = dietsPreTextByType[diet.selectedDiets] {
                            Text(preText)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        } else {
                            Text("少於")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                        Text(String(diet.dietsValue))
                            .foregroundColor(Color.gray)
                        if let primaryUnits = dietsUnitsByType[diet.selectedDiets] {
                            Text(primaryUnits.first!)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        } else {
                            Text("次")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
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
                        DatePicker("結束日期", selection: $diet.dueDateTime, displayedComponents: [.date])
                            .onChange(of: diet.dueDateTime) { newValue in
                                diet.dueDateTime = newValue
                            }
                    }
                }
                Section {
                    TextField("備註", text: $diet.todoNote)
                        .onChange(of: diet.todoNote) { newValue in
                            diet.todoNote = newValue
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
                                deleteTodo{_ in }
                            },
                            secondaryButton: .cancel(Text("取消"))
                        )
                    }
                    
                    Button(action: {
                        reviseDiet{_ in }
                        if diet.label == "" {
                            diet.label = "notSet"
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
                .listRowBackground(Color.clear)
            }
            .navigationBarTitle("一般學習修改")
            .navigationBarItems(trailing: EmptyView())
    }
    
    func reviseDiet(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": diet.id,
            "title": diet.title,
            "label": diet.label,
            "description": diet.description,
            "reminderTime": formattedTime(diet.reminderTime),
            "dueDateTime": formattedDate(diet.dueDateTime),
            "todoNote": diet.todoNote
        ]
        phpUrl(php: "reviseStudy" ,type: "reviseTask",body:body, store: nil){ message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.isError = true
                    self.messenge = "習慣建立錯誤 請聯繫管理員"
                    print("修改飲食回傳：\(String(describing: message["message"]))")
                }
                completion(message["message"]!)
            }
        }
    }
    
    func deleteTodo(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": diet.id,
            "type": "StudyGeneral",
        ]
        
        phpUrl(php: "deleteTodo", type: "reviseTask", body: body, store: nil) { message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.dietStore.deleteTodo(withID: self.diet.id)
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
struct DietDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var diet = Diet(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                               selectedDiets: "減醣",
                               dietsValue: 1,
                               recurringUnit: "每週",
                               recurringOption:2,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註",
                               RecurringStartDate: Date(),
                               RecurringEndDate: Date(),
                               completeValue:  0)
        DietDetailView(diet: $diet)
    }
}
