//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI

struct StudyDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var todo: Todo
    @EnvironmentObject var todoStore: TodoStore
    @State private var showAlert = false
    
    
    @State var messenge = "123"
    @State var isError = false
    
    var body: some View {
            Form {
                Section {
                    Text(todo.title)
                        .foregroundColor(Color.gray)
                    Text(todo.description)
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
                        TextField("標籤", text: $todo.label)
                            .onChange(of: todo.label) { newValue in
                                todo.label = newValue
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
                        Text(formattedDate(todo.startDateTime))
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
                        DatePicker("提醒時間", selection: $todo.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: todo.reminderTime) { newValue in
                                todo.reminderTime = newValue
                            }
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "book.closed.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        Text("目標")
                        Spacer()
                        Text(todo.recurringUnit)
                            .foregroundColor(Color.gray)
                        Text(String(todo.studyValue))
                            .foregroundColor(Color.gray)
                        Text(todo.studyUnit)
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
                        DatePicker("結束日期", selection: $todo.dueDateTime, displayedComponents: [.date])
                            .onChange(of: todo.dueDateTime) { newValue in
                                todo.dueDateTime = newValue
                            }
                    }
                }
                Section {
                    TextField("備註", text: $todo.todoNote)
                        .onChange(of: todo.todoNote) { newValue in
                            todo.todoNote = newValue
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
                            reviseTodo{_ in }
                            if todo.label == "" {
                                todo.label = "notSet"
                            }
                         print("我按完成了")
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
    
    func reviseTodo(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": todo.id,
            "title": todo.title,
            "label": todo.label,
            "description": todo.description,
            "reminderTime": formattedTime(todo.reminderTime),
            "dueDateTime": formattedDate(todo.dueDateTime),
            "todoNote": todo.todoNote
        ]
        
        phpUrl(php: "reviseStudy", type: "reviseTask", body: body, store: nil) { message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.isError = true
                    self.messenge = "習慣修改錯誤 請聯繫管理員"
                    print("修改一般學習回傳：\(String(describing: message["message"]))")
                }
                completion(message["message"]!)
            }
        }
    }
    
    func deleteTodo(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": todo.id,
            "type": "StudyGeneral",
        ]
        
        phpUrl(php: "deleteTodo", type: "reviseTask", body: body, store: nil) { message in
            DispatchQueue.main.async {
                if message["message"] == "Success" {
                    self.isError = false
                    self.messenge = ""
                    self.todoStore.deleteTodo(withID: self.todo.id)
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

struct StudyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var todo = Todo(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                               studyValue: 3.0,
                               studyUnit: "小時",
                               recurringUnit:"每週",
                               recurringOption:2,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註",
                               RecurringStartDate: Date(),
                               RecurringEndDate: Date(),
                               completeValue:  0)
        StudyDetailView(todo: $todo)
    }
}
