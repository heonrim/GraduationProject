
import SwiftUI
import Foundation

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum IndicatorType: String, CaseIterable {
    case week = "週"
    case month = "月"
    case year = "年"
}

enum TaskCategory: String, CaseIterable {
    case generalLearning = "一般學習"
    case spacedLearning = "間隔學習"
    case sport = "運動"
    case diet = "飲食"
    case routine = "作息"
}

struct HabitTask: Identifiable {
    let id = UUID()
    let name: String
}

struct HabitTrackingIndicatorView: View {
    @State private var selectedCategory = TaskCategory.generalLearning
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @State private var tasks: [HabitTask] = [
        HabitTask(name: "背英文單字"),
        HabitTask(name: "游泳"),
        HabitTask(name: "減糖")
    ]
    @State private var selectedTask: TaskItem?
    
    var body: some View {
        VStack {
            Text("習慣追蹤指標")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#6B6B6B"))
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .fontWeight(.medium)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(self.selectedCategory == category ? Color(hex: "#3B82F6") : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(self.selectedCategory == category ? .white : Color(hex: "#6B6B6B").opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            
            // Task List
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(tasksForCategory(selectedCategory).indices, id: \.self) { index in
                        TaskRow(task: tasksForCategory(selectedCategory)[index], selectedTask: $selectedTask, selectedCategory: $selectedCategory)
                    }
                }
                .padding()
            }
            .background(Color(hex: "#EFEFEF").edgesIgnoringSafeArea(.all))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
    
    func tasksForCategory(_ category: TaskCategory) -> [Any] {
        switch category {
        case .generalLearning:
            return todoStore.todos
        case .spacedLearning:
            return taskStore.tasks
        case .sport:
            return sportStore.sports
        case .diet:
            return dietStore.diets
        case .routine:
            return routineStore.routines
        }
    }
    
    struct TaskItem: Identifiable {
        var id: Int
        var task: Any
        var name: String
        var targetvalue: Float
        var selectedDiets: String
        var repetitionDay: [String]
        var repetitionCheck: [Double]
        
        init(id: Int, task: Any, taskName: String, targetvalue: Float, selectedDiets: String, repetitionDay: [String], repetitionCheck: [Double]) {
            self.id = id
            self.task = task
            self.name = taskName
            self.targetvalue = targetvalue
            self.selectedDiets = selectedDiets
            self.repetitionDay = repetitionDay
            self.repetitionCheck = repetitionCheck
        }
    }
    
    struct TaskRow: View {
        var task: Any
        @State private var id:Int = 0
        @State private var name:String = "TaskName"
        @State private var targetvalue:Float? = 0.0
        @State private var selectedDiets:String = ""
        @State private var repetitionDay: [String] = []
        @State private var repetitionCheck: [Double] = []
        @Binding var selectedTask: TaskItem?
        @Binding var selectedCategory: TaskCategory
        var body: some View {
            Button(action: {
                print("印出來的內容：\(task)")
                let result = selectedTaskFromStore(store: task, selectedCategory)
                print("result:\(result)")
                id = result.id
                name = result.name
                targetvalue = result.targetvalue
                selectedDiets = result.selectedDiets
                repetitionDay = result.repetitionDay
                repetitionCheck = result.repetitionCheck
                print("targetvalue:\(targetvalue)")
                print("repetition:\(repetitionDay)")
                print("repetition:\(repetitionCheck)")
                print(type(of: targetvalue))
                let selected = TaskItem(id: id,task: task, taskName: name, targetvalue: targetvalue ?? 0.0, selectedDiets: selectedDiets, repetitionDay: repetitionDay, repetitionCheck: repetitionCheck)
                $selectedTask.wrappedValue = selected
                print("selectedTask:\(selectedTask)")
                
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#91A3B0"))
                        .padding([.leading, .trailing], 15)
                    Text(taskTitle(for: task))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#6B6B6B"))
                        .padding([.top, .bottom, .trailing], 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(taskDescription(for: task))
                        .fontWeight(.thin)
                        .foregroundColor(Color(hex: "#6B6B6B"))
                        .padding([.top, .bottom, .trailing], 10)
                        .frame( alignment: .trailing)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task,id: task.id, taskName: task.name, targetvalue: task.targetvalue, selectedDiets: task.selectedDiets, repetitionDay: task.repetitionDay, repetitionCheck: task.repetitionCheck)
            }
        }
        
        func taskTitle(for task: Any) -> String {
            if let todo = task as? Todo {
                return todo.title
            } else if let task = task as? Task {
                return task.title
            } else if let sport = task as? Sport {
                return sport.title
            } else if let diet = task as? Diet {
                return diet.title
            } else if let routine = task as? Routine {
                return routine.title
            }
            return ""
        }
        
        func taskDescription(for task: Any) -> String {
            if let task = task as? Task {
                return task.description
            }
            return ""
        }
        
        func selectedTaskFromStore(store: Any, _ category: TaskCategory) -> (id: Int, name: String, targetvalue: Float, selectedDiets: String, repetitionDay: [String], repetitionCheck: [Double]) {
            
            switch category {
            case .generalLearning:
                return ((store as! Todo).id, (store as! Todo).title, (store as! Todo).studyValue, "", [], [])
            case .spacedLearning:
                return ((store as! Task).id, (store as! Task).title, 0.0, "", [formattedDate((store as! Task).repetition1Count), formattedDate((store as! Task).repetition2Count), formattedDate((store as! Task).repetition3Count), formattedDate((store as! Task).repetition4Count)], [(store as! Task).isReviewChecked0 ? 0.25 : 0.0, (store as! Task).isReviewChecked1 ? 0.25 : 0.0, (store as! Task).isReviewChecked2 ? 0.25 : 0.0, (store as! Task).isReviewChecked3 ? 0.25 : 0.0])
            case .sport:
                return ((store as! Sport).id, (store as! Sport).title, (store as! Sport).sportValue, "", [], [])
            case .diet:
                return ((store as! Diet).id, (store as! Diet).title, Float((store as! Diet).dietsValue), (store as! Diet).selectedDiets, [], [])
            case .routine:
                return ((store as! Routine).id, (store as! Routine).title, Float((store as! Routine).routineValue), "", [], [])
            }
            
        }
    }
}

struct TaskDetailView: View {
    var task: Any
    var id: Int?
    var taskName: String
    var targetvalue: Float? = 0.0
    var selectedDiets:String = ""
    var repetitionDay: [String] = []
    var repetitionCheck: [Double] = []
    let completionRatesViewModel = CompletionRatesViewModel()
    @State private var selectedIndicator = IndicatorType.week
    
    var body: some View {
        VStack(spacing: 20) {
            Text(taskName)
                .font(.system(size: 30, weight: .semibold, design: .default))
                .foregroundColor(Color(hex: "#4A4A4A"))
                .padding(.top, 20)
            // spaced -> X
            if targetvalue != 0.0 {
                Picker("Indicator", selection: $selectedIndicator) {
                    ForEach(IndicatorType.allCases, id: \.self) { indicator in
                        Text(indicator.rawValue).tag(indicator)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 10)
                .background(Color(hex: "#EFEFEF"))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            } else {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            ReportView(id: id ?? 0, targetvalue: targetvalue, selectedDiets: selectedDiets, repetitionDay: repetitionDay, repetitionCheck: repetitionCheck,selectedIndicator: $selectedIndicator, completionRatesViewModel: completionRatesViewModel)
                .transition(.slide)
            Spacer()
        }
        .onAppear() {
            print(task)
        }
        .padding()
        .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom))
    }
}

struct ProgressBar: View {
    var value: Double
    var selectedDiets: String
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(hex: "#E0E0E0"))
                    .cornerRadius(5)
                
                Rectangle()
                    .fill(selectedDiets == "減糖" || selectedDiets == "少油炸" ? Color(hex: "#B09191") : Color(hex: "#91A3B0"))
                    .cornerRadius(5)
                    .frame(width: geometry.size.width * CGFloat(value))
            }
        }
        .overlay(
            Text("\(Int(value * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "#6B6B6B"))
        )
    }
}

struct ReportView: View {
    let id: Int
    let targetvalue: Float?
    var selectedDiets:String = ""
    var repetitionDay: [String] = []
    var repetitionCheck: [Double] = []
    @Binding var selectedIndicator: IndicatorType
    @State private var selectedDate = Date()
    @State private var Instance_id: Int = 0
    @State private var selectedDateToString = ""
    @ObservedObject var completionRatesViewModel: CompletionRatesViewModel
    var datesOfWeek: [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: selectedDate) {
                print("datesOfWeek-\(i):\(date)")
                print("formattedDate datesOfWeek-\(i):\(GraduationProject.formattedDate(date))")
                dates.append(GraduationProject.formattedDate(date))
            }
        }
        return dates
    }
    
    var datesOfMonth: [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        guard let startOfMonth = calendar.date(from: components),
              let rangeOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth) else { return dates }
        
        for day in rangeOfMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(GraduationProject.formattedDate(date))
            }
        }
        return dates
    }
    
    let months = [
        "01月", "02月", "03月", "04月",
        "05月", "06月", "07月", "08月",
        "09月", "10月", "11月", "12月"
    ]
    
    func dayList(cycleCategory: IndicatorType) -> ([String]) {
        
        if targetvalue != 0.0 {
            switch cycleCategory {
            case .week:
                return datesOfWeek
            case .month:
                return datesOfMonth
            case .year:
                return months
            }
        } else {
            return repetitionDay
        }
        
    }
    
    var body: some View {
        VStack {
            if targetvalue != 0.0 {
                DateSelectionView(id: id, targetvalue: targetvalue, selectedIndicator: $selectedIndicator, selectedDate: $selectedDate, completionRatesViewModel: completionRatesViewModel)
            }
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(dayList(cycleCategory: selectedIndicator), id: \.self) { date in
                        HStack {
                            Text(date)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .frame(alignment: .leading)
                            Spacer()
                            if selectedIndicator == .year {
                                ProgressBar(value: completionRatesViewModel.completionRates["\(selectedDateToString)\(date)"] ?? 0, selectedDiets: selectedDiets)
                                    .frame(width: 235, height: 20)
                                    .animation(.easeInOut(duration: 1.0))
                                    .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                    .padding(5)
                            } else {
                                ProgressBar(value: completionRatesViewModel.completionRates[date] ?? 0, selectedDiets: selectedDiets)
                                    .frame(width: 235, height: 20)
                                    .animation(.easeInOut(duration: 1.0))
                                    .background(Color(hex: "#EFEFEF").cornerRadius(5))
                                    .padding(5)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.all, 10)
            }
            .frame(width: 325)
        }
        .onChange(of: selectedIndicator) { _ in
            fetchDataAndUpdate()
            if selectedIndicator == .year {
                selectedDateToString = DateFormatter.yearFormatter.string(from: selectedDate)
            }
        }
        .onAppear() {
            fetchDataAndUpdate()
        }
        .background(Color(hex: "#FAFAFA"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.all, 10)
    }
    func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return dateFormatter
    }
    func fetchDataAndUpdate() {
        if targetvalue != 0.0 {
            TrackingFirstDay(id: id) { selectedDate, instanceID in
                self.selectedDate = selectedDate
                self.Instance_id = instanceID
                RecurringCheckList(id: id, targetvalue: targetvalue ?? 1.0, store: completionRatesViewModel) { _ in}
            }
        } else {
            if repetitionDay.count == repetitionCheck.count {
                let dictionary = Dictionary(uniqueKeysWithValues: zip(repetitionDay, repetitionCheck))
                completionRatesViewModel.completionRates = dictionary
                print(dictionary)
            } else {
                print("鍵和值的數量不一致，無法組合成字典。")
            }
            
        }
    }
}

struct DateSelectionView: View {
    let id: Int
    let targetvalue: Float?
    //    let selectedIndicator: IndicatorType
    @Binding var selectedIndicator: IndicatorType
    @Binding var selectedDate: Date
    @ObservedObject var completionRatesViewModel: CompletionRatesViewModel
    @State private var value = 0
    @State private var selectedDateToString = ""
    @State private var Instance_id: Int = 0
    
    func arrowSelectedDateToString(arrow:String, cycleCategory: IndicatorType, newDate: Date) -> String {
        if (arrow == "left") {
            value = -1
        } else if (arrow == "right"){
            value = 1
        } else {
            value = 0
        }
        switch cycleCategory {
        case .week:
            print("DateSelectionView First selectedDate - \(newDate)")
            let startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: newDate) ?? newDate
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedDate)!
            let startOfWeekToString = DateFormatter.weekFormatter.string(from: startOfWeek)
            let endOfWeekToString = DateFormatter.weekFormatter.string(from: endOfWeek)
            selectedDate = startOfWeek
            return "\(startOfWeekToString) - \(endOfWeekToString)"
        case .month:
            selectedDate = Calendar.current.date(byAdding: .month, value: value, to: newDate) ?? newDate
            let formattedDate = DateFormatter.monthFormatter.string(from: selectedDate)
            return "\(formattedDate)"
        case .year:
            selectedDate = Calendar.current.date(byAdding: .year, value: value, to: newDate) ?? newDate
            let formattedDate = DateFormatter.yearFormatter.string(from: selectedDate)
            return "\(formattedDate)"
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {
                selectedDateToString = arrowSelectedDateToString(arrow:"left", cycleCategory: selectedIndicator, newDate: selectedDate)
            }) {
                Image(systemName: "arrow.left")
            }
            Spacer()
            Text("\(selectedDateToString)")
                .font(.headline)
                .onChange(of: selectedIndicator) { newValue in
                    selectedDateToString = arrowSelectedDateToString(arrow:"today", cycleCategory: selectedIndicator, newDate: selectedDate)
                }
            Spacer()
            Button(action: {
                selectedDateToString = arrowSelectedDateToString(arrow:"right", cycleCategory: selectedIndicator, newDate: selectedDate)
            }) {
                Image(systemName: "arrow.right")
            }
        }
        
        .onChange(of: selectedDate) { newDate in
            print("Selected date changed to: \(newDate)")
            print("DateSelectionView - \(completionRatesViewModel.completionRates)")
            selectedDateToString = arrowSelectedDateToString(arrow:"today", cycleCategory: selectedIndicator, newDate: newDate)
        }
        .padding()
    }
}

struct HabitTrackingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackingIndicatorView()
    }
}
