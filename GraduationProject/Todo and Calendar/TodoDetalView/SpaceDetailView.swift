//
//  TodoDetailView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct SpaceDetailView: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskStore: TaskStore
    @State var title = ""
    @State var description = ""
    @State var nextReviewTime = Date()
    @State var repetition1Status:Int = 0
    @State var repetition2Status:Int = 0
    @State var repetition3Status:Int = 0
    @State var repetition4Status:Int = 0
    @State var messenge = ""
    @State var isError = false
    @State private var showAlert = false
    
    struct reviseUserData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var message: String
    }
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: task.nextReviewDate)! }
    }
    
    var body: some View {
            Form {
                Section {
                    Text(task.title)
                        .foregroundColor(Color.gray)
                    Text(task.description)
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
                        TextField("標籤", text: $task.label)
                            .onChange(of: task.label) { newValue in
                                task.label = newValue
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
                        Text(formattedDate(task.nextReviewDate))
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
                        DatePicker("提醒時間", selection: $task.nextReviewTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: task.nextReviewTime) { newValue in
                                task.nextReviewTime = newValue
                            }
                        
                    }
                }
                Section {
                    ForEach(0..<4) { index in
                        HStack {
                            Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                        }
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
                    
                    Button(action: { reviseStudySpaced{_ in }}) {
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
            .navigationTitle("間隔學習修改")
        .onAppear() {
            task.title = task.title
            task.description = task.description
            task.nextReviewTime = task.nextReviewTime
        }
    }
    
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func reviseStudySpaced(completion: @escaping (String) -> Void) {
        let body = [ "id": task.id,
                     "title": task.title,
                     "label": task.label,
                     "description": task.description,
                     "reminderTime": formattedTime(task.nextReviewTime)] as [String : Any]
        
        phpUrl(php: "reviseSpace" ,type: "reviseTask",body:body, store: nil){ message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.isError = true
                    self.messenge = "習慣修改錯誤 請聯繫管理員"
                    print("修改間隔學習回傳：\(String(describing: message["message"]))")
                }
                completion(message["message"]!)
            }
        }
    }
    
    func deleteTodo(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": task.id,
            "type": "StudySpacedRepetition",
        ]
        
        phpUrl(php: "deleteTodo", type: "reviseTask", body: body, store: nil) { message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.taskStore.deleteTodo(withID: self.task.id)
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

struct TaskDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        // 創建一個@State變數
        @State var task = Task(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               nextReviewDate: Date(),
                               nextReviewTime: Date(),
                               repetition1Count: Date(),
                               repetition2Count: Date(),
                               repetition3Count: Date(),
                               repetition4Count: Date(),
                               isReviewChecked0: true,
                               isReviewChecked1: false,
                               isReviewChecked2: false,
                               isReviewChecked3: false)
        
        SpaceDetailView(task: $task) 
    }
}
