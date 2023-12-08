//
//  CheckDietView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/5.
//

import SwiftUI
import Combine

struct CheckDietView: View {
    @State var dietValue: Int = 0
    @State var accumulatedValue: Int = 0
    @State var isTaskSuccess: Bool = false
    @State var isFail: Bool = false
    let dietUnits = ["次", "小時"]
    @State var dietUnit: String = "次"
    @State var dietType: String = "次"
    let habitType: String = "飲食"
    let dietsUnitsByType: [String: [String]] = [
        "減糖": ["次"],
        "多喝水": ["豪升"],
        "少油炸": ["次"],
        "多吃蔬果": ["份"]
    ]
    
    
    let titleColor = Color(red: 229/255, green: 86/255, blue: 4/255)
    let customBlue = Color(red: 175/255, green: 168/255, blue: 149/255)
    var task: Diet
    @EnvironmentObject var dietStore: DietStore
    static let remainingValuePublisher = PassthroughSubject<(isCompleted: Bool,isFail: Bool, dietType: String), Never>()
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 1)
                
                Text("習慣類型：\(habitType)")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 1)
                
                Text("飲食類型: \(task.selectedDiets)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 1)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("目標")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text("\(task.dietsValue) \(dietUnit)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("已完成")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text("\(accumulatedValue) \(dietUnit)")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                    }
                }
                .padding(.horizontal, 10)
                
                HStack {
                    TextField("數值", value: $dietValue, format: .number)
                        .keyboardType(.decimalPad)
                        .frame(width: 70, height: 35)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(((task.selectedDiets == "減糖" || task.selectedDiets == "少油炸") && isFail == true && isTaskSuccess == false) || ((task.selectedDiets == "多喝水" || task.selectedDiets == "多吃蔬果") && isFail == false && isTaskSuccess == true) ? Color.gray : Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                        )
                        .cornerRadius(8)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .disabled(isFail == true)
                    
                    Text(dietUnit)
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .foregroundColor(customBlue)
                        .frame(width: 100, alignment: .trailing)
                    
                    Button(action: {
                        accumulatedValue += dietValue
                        dietStore.updateCompleteValue(withID: task.id, newValue: accumulatedValue)
                        
                        
                        // 判斷是否成功
                        switch task.selectedDiets {
                        case "減糖", "少油炸":
                            isTaskSuccess = accumulatedValue <= task.dietsValue
                            isFail = accumulatedValue > task.dietsValue
                        case "多喝水", "多吃蔬果":
                            isTaskSuccess = accumulatedValue >= task.dietsValue
                        default:
                            break
                        }
                        CheckDietView.remainingValuePublisher.send((isCompleted: isTaskSuccess,isFail: isFail, dietType: dietType))
                        upDateCompleteValue{_ in }
                    }) {
                        Image(systemName: isFail == true ? "xmark" : "checkmark")
                            .foregroundColor(isFail == true ? Color.gray : Color.white)
                            .padding(6)
                            .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                            .font(.system(size: 16))
                    }
                    .disabled(isFail == true || dietValue <= 0)
                }
                .padding(.horizontal, 10)
            }
            .padding(12)
            
            Group {
                if (task.selectedDiets == "減糖" || task.selectedDiets == "少油炸") && isTaskSuccess == false {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(15)
                        .background(Circle().fill(Color.red))
                }
                else if (task.selectedDiets == "多喝水" || task.selectedDiets == "多吃蔬果") && isTaskSuccess == true {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(15)
                        .background(Circle().fill(Color.green))
                }
            }
        }
        .background(
            (task.selectedDiets == "減糖" || task.selectedDiets == "少油炸") && isTaskSuccess == false ? Color.gray :
                (task.selectedDiets == "多喝水" || task.selectedDiets == "多吃蔬果") && isTaskSuccess == true ? Color.gray :
                Color.clear
        )
        .onAppear() {
            dietType = task.selectedDiets
            dietUnit = dietsUnitsByType[task.selectedDiets]?[0] ?? "次"
            accumulatedValue = Int(task.completeValue)
            switch task.selectedDiets {
            case "減糖", "少油炸":
                isTaskSuccess = accumulatedValue <= task.dietsValue
                isFail = accumulatedValue > task.dietsValue
            case "多喝水", "多吃蔬果":
                isTaskSuccess = accumulatedValue >= task.dietsValue
            default:
                break
            }
        }
    }
    func upDateCompleteValue(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": task.id,
            "RecurringStartDate": formattedDate(task.RecurringStartDate),
            "RecurringEndDate": formattedDate(task.RecurringEndDate),
            "completeValue": dietValue,
            "isComplete": isTaskSuccess,
        ]
        print("body:\(body)")
        phpUrl(php: "upDateCompleteValue" ,type: "reviseTask",body:body, store: nil){ message in
            completion(message["message"]!)
        }
    }
}

struct CheckDietView_Previews: PreviewProvider {
    @State static var  sampleTodo = Diet(
        id: 1,
        label: "SampleLabel",
        title: "SampleTitle",
        description: "SampleDescription",
        startDateTime: Date(),
        selectedDiets: "多喝水",
        dietsValue: 5,
        recurringUnit: "daily",
        recurringOption: 1,
        todoStatus: false,
        dueDateTime: Date(),
        reminderTime: Date(),
        todoNote: "SampleNote",
        RecurringStartDate: Date(),
        RecurringEndDate: Date(),
        completeValue: 0.0
    )
    static var previews: some View {
        CheckDietView(task: sampleTodo)
            .environmentObject(TaskService.shared)
    }
}
