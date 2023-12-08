//
//  AddDietsView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct AddDietView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dietStore: DietStore
    
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
    @State private var showDietsPicker = false
    @State private var selectedTimeUnit: String = "每日"
    let diets = [
        "減糖", "多喝水", "少油炸", "多吃蔬果"
    ]
    
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
    let timeUnits = ["每日", "每週", "每月"]
    
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    @State private var selectedDiets = "減糖"
    @State private var recurringUnit = "每日"
    @State private var dietsValue: Int = 0
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
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 8)
                        
                        Text("飲食類型")
                        
                        Spacer()
                        
                        Button(action: {
                            self.showDietsPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedDiets)
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if showDietsPicker {
                        Picker("飲食類型", selection: $selectedDiets) {
                            ForEach(diets, id: \.self) { diet in
                                Text(diet).tag(diet)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    HStack(spacing: 10) {
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
                        
                        if let preText = dietsPreTextByType[selectedDiets] {
                            Text(preText)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        TextField("數值", value: $dietsValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 60, alignment: .leading)
                        
                        if let primaryUnits = dietsUnitsByType[selectedDiets] {
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
            .navigationBarTitle("飲食")
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("返回")
                                            .foregroundColor(.blue)
                                                },
                                trailing: Button("完成"){addDiet {_ in }}
                .disabled(todoTitle.isEmpty && todoIntroduction.isEmpty))
            
        }
    }
    
    func addDiet(completion: @escaping (String) -> Void) {
        var body = ["label": label,
                    "todoTitle": todoTitle,
                    "todoIntroduction": todoIntroduction,
                    "startDateTime": formattedDate(startDateTime),
                    "dietType": selectedDiets,
                    "dietValue": dietsValue,
                    "reminderTime": formattedTime(reminderTime),
                    "todoNote": todoNote] as [String : Any]
        
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
        print("addDiet:\(body)")
        print("selectedTimeUnit:\(selectedTimeUnit)")
        phpUrl(php: "addDiet" ,type: "addTask",body:body,store: dietStore){ message in
            print("建立飲食回傳：\(String(describing: message["message"]))")
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
struct AddDietView_Previews: PreviewProvider {
    static var previews: some View {
        AddDietView()
    }
}
