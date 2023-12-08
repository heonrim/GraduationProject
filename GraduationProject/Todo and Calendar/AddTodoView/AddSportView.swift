//
//  AddSportView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct AddSportView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sportStore: SportStore
    
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
    @State var sportType: String = ""
    @State private var sportValue: Float = 0.0
    @State private var sportUnit: String = "次"
    @State private var SportUnit: Int = 0
    @State private var showSportPicker = false
    @State private var selectedSport = "跑步"
    @State private var selectedTimeUnit: String = "每日"
    
    
    let sports = [
        "跑步", "單車騎行", "散步", "游泳", "爬樓梯", "健身",
        "瑜伽", "舞蹈", "滑板", "溜冰", "滑雪", "跳繩",
        "高爾夫", "網球", "籃球", "足球", "排球", "棒球",
        "曲棍球", "壁球", "羽毛球", "舉重", "壁球", "劍道",
        "拳擊", "柔道", "跆拳道", "柔術", "舞劍", "團體健身課程"
    ]

    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false
    let timeUnits = ["每日", "每週", "每月"]
    let sportUnits = ["小時", "次", "卡路里"]
    
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
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        
                        Text("運動類型")
                        
                        Spacer()
                        
                        Button(action: {
                            self.showSportPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedSport)
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if showSportPicker {
                        Picker("運動類型", selection: $selectedSport) {
                            ForEach(sports, id: \.self) { sport in
                                Text(sport).tag(sport)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
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
                        
                        TextField("輸入數值", value: $sportValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 80, alignment: .center)
                        
                        Picker("選擇單位", selection: $sportUnit) {
                            ForEach(sportUnits, id: \.self) { unit in
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
            .navigationBarTitle("運動")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成") {addSport {_ in }}
                .disabled(todoTitle.isEmpty && todoIntroduction.isEmpty))
        }
    }
    
    func addSport(completion: @escaping (String) -> Void) {
        if sportUnit == "小時" {
            SportUnit = 0
        } else if sportUnit == "次" {
            SportUnit = 1
        } else if sportUnit == "卡路里" {
            SportUnit = 2
        }
        var body: [String: Any] = [
            "label": label,
            "todoTitle": todoTitle,
            "todoIntroduction": todoIntroduction,
            "startDateTime": formattedDate(startDateTime),
            "sportType": selectedSport,
            "sportValue": sportValue,
            "SportUnit": SportUnit,
            "reminderTime": formattedTime(reminderTime),
            "todoNote": todoNote
        ]
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
        print("addSport:\(body)")
        print("selectedTimeUnit:\(selectedTimeUnit)")
        phpUrl(php: "addSport" ,type: "addTask",body:body,store: sportStore) { message in
            print("建立運動回傳：\(String(describing: message["message"]))")
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
struct AddSportView_Previews: PreviewProvider {
    static var previews: some View {
        AddSportView()
    }
}
