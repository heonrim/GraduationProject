//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI
import Foundation

struct AddStudyView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoStore: TodoStore

    @State var label: String = ""
    @State var todoTitle: String = ""
    @State var todoIntroduction: String = ""
    @State var startDateTime: Date = Date()
    @State var todoStatus: Bool = false
    @State var reminderTime: Date = Date()
    @State var todoNote: String = ""
    @State private var studyValue: Float = 0.0
    @State private var recurringOption = 1  // 1: 持續重複, 2: 選擇結束日期
    @State private var recurringEndDate = Date()
    @State private var selectedTimeUnit: String = "每日"
    @State private var studyUnit: String = "次"
    let studyUnits = ["次", "小時"]
    let timeUnits = ["每日", "每週", "每月"]
    @State var messenge = ""
    @State var isError = false
    
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
                        Menu {
                            ForEach(timeUnits, id: \.self) { unit in
                                Button(action: {
                                    selectedTimeUnit = unit
                                }) {
                                    Text(unit)
                                }
                            }
                        } label: {
                            Text(selectedTimeUnit)
                                .padding(.trailing)
                        }
                        
                        Spacer()
                        
                        TextField("輸入數值", value: $studyValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 80, alignment: .center)
                        
                        Picker("選擇單位", selection: $studyUnit) {
                            ForEach(studyUnits, id: \.self) { unit in
                                Text(unit)
                                    .font(.system(size: 12))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150, alignment: .trailing)
                        
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120, alignment: .trailing)
                    }
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
            .navigationBarTitle("一般學習")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成") { StudyGeneralAdd{_ in }}
                .disabled(todoTitle.isEmpty && todoIntroduction.isEmpty)
            )
        }
    }
    
    func StudyGeneralAdd(completion: @escaping (String) -> Void) {
        var body: [String: Any] = [
            "label": label,
            "todoTitle": todoTitle,
            "todoIntroduction": todoIntroduction,
            "startDateTime": formattedDate(startDateTime),
            "studyValue": studyValue,
            "reminderTime": formattedTime(reminderTime),
            "todoNote": todoNote
        ]
        if studyUnit == "小時" {
            body["studyUnit"] = 0
        } else if studyUnit == "次" {
            body["studyUnit"] = 1
        }
        if selectedTimeUnit == "每日" {
            body["frequency"] = 1
        } else if selectedTimeUnit == "每週" {
            body["frequency"] = 2
        } else if selectedTimeUnit == "每月" {
            body["frequency"] = 3
        }
        if recurringOption == 1 {
            // 持續重複
            body["dueDateTime"] = formattedDate(Calendar.current.date(byAdding: .year, value: 5, to: recurringEndDate)!)
        } else {
            // 選擇結束日期
            body["dueDateTime"] = formattedDate(recurringEndDate)
        }
        print("StudyGeneralAdd:\(body)")
        phpUrl(php: "addStudyGeneral" ,type: "addTask",body:body,store: todoStore) { message in
            print("建立一般學習回傳：\(String(describing: message["message"]))")
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

struct AddStudyView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudyView()
            .environmentObject(TodoStore())
    }
}
