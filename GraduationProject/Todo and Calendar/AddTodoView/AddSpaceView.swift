//
//  AddSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import Foundation
import SwiftUI

struct AddSpaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskStore: TaskStore
    
    @State var title = ""
    @State var description = ""
    @State var label: String = ""
    @State var nextReviewDate = Date()
    @State var nextReviewTime = Date()
    @State var repetition1Count = Date()
    @State var repetition2Count = Date()
    @State var repetition3Count = Date()
    @State var repetition4Count = Date()
    @State var messenge = ""
    @State var isError = false
    
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: nextReviewDate)! }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("標題", text: $title)
                    TextField("內容", text: $description)
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
                        DatePicker("選擇時間", selection: $nextReviewDate, displayedComponents: [.date])
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
                        DatePicker("提醒時間", selection: $nextReviewTime, displayedComponents: [.hourAndMinute])
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
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("間隔學習")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button("完成") { addStudySpaced{_ in } }
                .disabled(title.isEmpty && description.isEmpty)
                .onDisappear() {
                    repetition1Count = nextReviewDates[0]
                    repetition2Count = nextReviewDates[1]
                    repetition3Count = nextReviewDates[2]
                    repetition4Count = nextReviewDates[3]
                }
            )
        }
    }
    
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func addStudySpaced(completion: @escaping (String) -> Void) {
        var body: [String: Any] = [
            "title": title,
            "description": description,
            "label": label,
            "nextReviewDate": formattedDate(nextReviewDate),"nextReviewTime": formattedTime(nextReviewTime),
            "First": formattedDate(nextReviewDates[0]),"third": formattedDate(nextReviewDates[1]),
            "seventh": formattedDate(nextReviewDates[2]),"fourteenth": formattedDate(nextReviewDates[3]) ]
        print("addStudySpaced:\(body)")
        phpUrl(php: "addStudySpaced" ,type: "addTask",body:body,store: taskStore){ message in
            print("建立間隔學習法回傳：\(String(describing: message["message"]))")
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

struct AddSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpaceView()
            .environmentObject(TaskStore())
    }
}
