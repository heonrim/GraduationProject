//
//  CheckSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/24.
//

import SwiftUI
import Combine

struct Repetition {
    var date: Date
    var isChecked: Bool
}
struct CheckSpaceView: View {
    @State var accumulatedValue: Float = 0.0
    @State var isTaskCompleted: Bool  = false
    @State var isFail: Bool  = false
    @State private var isCompleted: Bool = false
    @State private var currentStageIndex: Int = 3
    
    let titleColor = Color(red: 229/255, green: 86/255, blue: 4/255)
    let customBlue = Color(red: 175/255, green: 168/255, blue: 149/255)
    var task: Task
    @EnvironmentObject var taskStore: TaskStore
    let habitType: String = "間隔學習"
    let intervalLearningType: String = "學習"
    static let remainingValuePublisher = PassthroughSubject<(Bool), Never>()
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 1)
                
                Text("內容：\(task.description)")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 1)
                
                IntervalProgressView(currentStage: currentStageIndex)
                
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isTaskCompleted = true
                    }
                    taskStore.updateCompleteValue(withID: task.id)
                    CheckSpaceView.remainingValuePublisher.send(isTaskCompleted)
                    upDateCompleteValue{_ in }


                }) {
                    Image(systemName: "checkmark")
                        .foregroundColor(isTaskCompleted || isFail ? Color.gray : Color.white)
                        .padding(6)
                        .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                        .font(.system(size: 16))
                }
                .disabled(isTaskCompleted || isFail)
                .padding(.horizontal, 10)
            }
            .padding(12)
            .background(isTaskCompleted || isFail ? Color.gray : Color.clear)
            if isTaskCompleted {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .background(Circle().fill(Color.green))
            } else if isFail {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .background(Circle().fill(Color.red))
            }
        }
        .background(isTaskCompleted || isFail ? Color.gray : Color.clear)
        .onAppear() {
            
            let today = formattedDate(Date())
            
            let repetitions = [
                Repetition(date: task.repetition1Count, isChecked: task.isReviewChecked0),
                Repetition(date: task.repetition2Count, isChecked: task.isReviewChecked1),
                Repetition(date: task.repetition3Count, isChecked: task.isReviewChecked2),
                Repetition(date: task.repetition4Count, isChecked: task.isReviewChecked3)
            ]
            
            for (index, repetition) in repetitions.enumerated() {
                
                if today > formattedDate(repetition.date) {
                    isFail = !repetition.isChecked
                } else if today == formattedDate(repetition.date) {
                    currentStageIndex = index
                    isTaskCompleted = repetition.isChecked
                    break
                }
            }
        }
    }
    func upDateCompleteValue(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "id": task.id,
            "value": currentStageIndex+1
        ]
        print("body:\(body)")
        phpUrl(php: "upDateSpaced" ,type: "reviseTask",body:body, store: nil){ message in
            completion(message["message"]!)
        }
    }
}

struct IntervalProgressView: View {
    
    var stages: [String] = ["第一次複習", "第二次複習", "第三次複習", "第四次複習"]
    var days: [String] = ["第一天", "第三天", "第七天", "第十四天"]
    var currentStage: Int //0-3表示間隔學習階段
    var completedStages: Set<Int> = []
    
    let morandiBlues = [
        Color(hex: "#639ab2"),
        Color(hex: "#638bb2"),
        Color(hex: "#637bb2"),
        Color(hex: "#636bb2")
    ]
    
    private func colorForStage(index: Int) -> Color {
        return morandiBlues[min(max(0, index), morandiBlues.count - 1)]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                ForEach(stages.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            if index == currentStage {
                                Circle()
                                    .fill(colorForStage(index: index))
                                    .frame(width: 8, height: 8)
                            }
                            Text(stages[index])
                                .font(.system(size: 12))
                                .fontWeight(index == currentStage ? .bold : .regular)
                                .foregroundColor(colorForStage(index: index))
                                .alignmentGuide(.firstTextBaseline) { context in
                                    context[.top]
                                }
                            if completedStages.contains(index) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.green)
                            }
                        }
                        Text(days[index])
                            .font(.system(size: 10))
                            .fontWeight(.light)
                            .foregroundColor(Color.secondary.opacity(0.5))
                            .alignmentGuide(.firstTextBaseline) { context in
                                context[.top]
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 5)
                    HStack(spacing: 0) {
                        ForEach(0..<currentStage, id: \.self) { stage in
                            Capsule()
                                .fill(self.colorForStage(index: stage))
                                .frame(width: geometry.size.width / CGFloat(stages.count))
                        }
                    }
                    .frame(height: 5)
                }
            }
            .frame(height: 20)
            .animation(.linear, value: currentStage)
        }
    }
}


struct CheckSpaceView_Previews: PreviewProvider {
    @State static var  sampleTodo = Task(
        id: 1,
        label: "SampleLabel",
        title: "SampleTitle",
        description: "SampleDescription",
        nextReviewDate: Date(),
        nextReviewTime: Date(),
        repetition1Count:  Date(),
        repetition2Count:  Date(),
        repetition3Count:  Date(),
        repetition4Count:  Date(),
        isReviewChecked0: false,
        isReviewChecked1: false,
        isReviewChecked2: false,
        isReviewChecked3: false
    )
    
    static var previews: some View {
        CheckSpaceView( task: sampleTodo)
            .environmentObject(TaskService.shared)
    }
}
