//
//  AddSportView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct DetailSportView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sportStore: SportStore
    @Binding var sport: Sport
    @State private var showAlert = false
    
    let sports = [
        "跑步", "單車騎行", "散步", "游泳", "爬樓梯", "健身",
        "瑜伽", "舞蹈", "滑板", "溜冰", "滑雪", "跳繩",
        "高爾夫", "網球", "籃球", "足球", "排球", "棒球",
        "曲棍球", "壁球", "羽毛球", "舉重", "壁球", "劍道",
        "拳擊", "柔道", "跆拳道", "柔術", "舞劍", "團體健身課程"
    ]
    
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false
    
    let sportUnits = ["小時", "次", "卡路里"]
    
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
                    Text(sport.title)
                        .foregroundColor(Color.gray)
                    Text(sport.description)
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
                        TextField("標籤", text: $sport.label)
                            .onChange(of: sport.label) { newValue in
                                sport.label = newValue
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
                        Text(formattedDate(sport.startDateTime))
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
                        DatePicker("提醒時間", selection: $sport.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: sport.reminderTime) { newValue in
                                sport.reminderTime = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        Text("目標")
                        Spacer()
                        Text(sport.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(sport.selectedSport)
                            .foregroundColor(Color.gray)
                        Text(String(sport.sportValue))
                            .foregroundColor(Color.gray)
                        Text(sport.sportUnits)
                            .foregroundColor(Color.gray)
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
                        DatePicker("結束日期", selection: $sport.dueDateTime, displayedComponents: [.date])
                            .onChange(of: sport.dueDateTime) { newValue in
                                sport.dueDateTime = newValue
                            }
                    }
                }
                Section {
                    TextField("備註", text: $sport.todoNote)
                        .onChange(of: sport.todoNote) { newValue in
                            sport.todoNote = newValue
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
                        reviseSport{_ in }
                        if sport.label == "" {
                            sport.label = "notSet"
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
            .navigationBarTitle("一般學習修改")
            .navigationBarItems(trailing: EmptyView())
    }
    
    func reviseSport(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": sport.id,
            "title": sport.title,
            "label": sport.label,
            "description": sport.description,
            "reminderTime": formattedTime(sport.reminderTime),
            "dueDateTime": formattedDate(sport.dueDateTime),
            "todoNote": sport.todoNote
        ]
        phpUrl(php: "reviseStudy" ,type: "reviseTask",body:body, store: nil){ message in
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
            "id": sport.id,
            "type": "Sport",
        ]
        
        phpUrl(php: "deleteTodo", type: "reviseTask", body: body, store: nil) { message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.sportStore.deleteTodo(withID: self.sport.id)
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
struct DetailSportView_Previews: PreviewProvider {
    static var previews: some View {
        @State var sport = Sport(id: 001,
                                 label:"我是標籤",
                                 title: "英文",
                                 description: "背L2單字",
                                 startDateTime: Date(),
                                 selectedSport: "溜冰",
                                 sportValue: 1.1,
                                 sportUnits: "次",
                                 recurringUnit: "每週",
                                 recurringOption:2,
                                 todoStatus: false,
                                 dueDateTime: Date(),
                                 reminderTime: Date(),
                                 todoNote: "我是備註",
                                 RecurringStartDate: Date(),
                                 RecurringEndDate: Date(),
                                 completeValue:  0)
        DetailSportView(sport: $sport)
    }
}
