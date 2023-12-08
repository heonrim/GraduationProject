//
//  CalendarView.swift
//  GraduationProject
//
//  Created by heonrim on 3/27/23.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

class MockData: ObservableObject {
    @Published var dietEvents: [Event]
    
    init() {
        self.dietEvents = [
            Event(title: "Event 1", date: Date()),
            Event(title: "Event 2", date: Date()),
            Event(title: "Event 3", date: Date())
        ]
    }
}

struct ImageStyle: ViewModifier {
    func body(content: Content) -> some View {
        if let image = content as? Image {
            return AnyView(image
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.black))
        } else {
            return AnyView(content)
        }
    }
}

extension Image {
    func styledAsIcon() -> some View {
        self.modifier(ImageStyle())
    }
}

struct CalendarView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @EnvironmentObject var mockData: MockData
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var selectedDate = Date()
    @State var showModal = false
    @State var frequency:Int = 0
    
    var switchViewAction: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    datePicker().padding(.top, 20)
                    
                    ScrollView(showsIndicators: false) {
                        eventList()
                            .padding()
                            .padding(.bottom, 10)
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color(hex: "cfd8dc")))
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 100)
                .padding(.top, -20)
                .padding(.bottom, 20)
            }
            .navigationBarTitle("行事曆", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: switchViewAction) {
                    Image(systemName: "list.bullet")
                        .styledAsIcon()
                        .foregroundColor(.black)
                },
                trailing: Button(action: { self.showingActionSheet = true }) {
                    Image(systemName: "plus")
                        .styledAsIcon()
                        .foregroundColor(.black)
                }
            )
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("新增事件"), message: Text("選擇一個事件類型"), buttons: [
                    .default(Text("一般學習"), action: {
                        self.action = .generalLearning
                    }),
                    .default(Text("間隔學習"), action: {
                        self.action = .spacedLearning
                    }),
                    .default(Text("運動"), action: {
                        self.action = .sport
                    }),
                    .default(Text("作息"), action: {
                        self.action = .routine
                    }),
                    .default(Text("飲食"), action: {
                        self.action = .diet
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(item: $action) { item in
                switch item {
                case .generalLearning:
                    AddStudyView()
                case .spacedLearning:
                    AddSpaceView()
                case .sport:
                    AddSportView()
                case .diet:
                    AddDietView()
                default:
                    AddRoutineView()
                }
            }
        }
        .onAppear() {
            print("todoList: \(todoStore.todos)")
        }
    }
    
    func datePicker() -> some View {
        VStack(spacing: 10) {
            DatePicker("", selection: $selectedDate, in: ...Date.distantFuture, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.5))
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                )
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func eventList() -> some View {
        let filteredTasks = taskStore.tasksForDate(selectedDate)
        let filteredTodos = todoStore.todosForDate(selectedDate)
        let filteredSports = sportStore.sportsForDate(selectedDate)
        let filteredDiets = dietStore.dietForDate(selectedDate)
        let filteredRoutines = routineStore.routineForDate(selectedDate)
        
        return VStack(spacing: 20) {
            Group {
                Text("間隔學習法")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredTasks) { task in
                    ModernEventRow(eventTitle: task.title, eventSubtitle: task.description, eventRecurringUnit: "", eventValue: "", eventUnit: "", eventSelectType: "", icon: "calendar")
                }
            }
            
            Group {
                Text("一般學習")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredTodos) { todo in
                    ModernEventRow(eventTitle: todo.title, eventSubtitle: "", eventRecurringUnit: todo.recurringUnit, eventValue:String(todo.studyValue), eventUnit: todo.studyUnit, eventSelectType: "", icon: "book")
                }
            }
            
            Group {
                Text("運動")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredSports) { sport in
                    ModernEventRow(eventTitle: sport.title, eventSubtitle: sport.description, eventRecurringUnit: sport.recurringUnit, eventValue: String(sport.sportValue), eventUnit: sport.sportUnits, eventSelectType: sport.selectedSport, icon: "figure.walk")
                }
            }
            
            Group {
                Text("飲食")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredDiets) { diet in
                    ModernEventRow(eventTitle: diet.title, eventSubtitle: diet.description, eventRecurringUnit: diet.recurringUnit, eventValue: String(diet.dietsValue), eventUnit: "", eventSelectType: diet.selectedDiets, icon: "fork.knife")
                }
            }
            
            Group {
                Text("作息")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredRoutines) { routine in
                    ModernEventRow(eventTitle: routine.title, eventSubtitle: routine.description, eventRecurringUnit: "", eventValue: String(routine.routineValue), eventUnit: formattedTime(routine.routineTime), eventSelectType: routine.selectedRoutines, icon: "bed.double.fill")
                }
            }
        }
    }
    
    struct ModernEventRow: View {
        var eventTitle: String
        var eventSubtitle: String
        var eventRecurringUnit: String
        var eventValue: String
        var eventUnit: String
        var eventSelectType: String
        var icon: String
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
        
        var body: some View {
            HStack(spacing: 15) {
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.blue.opacity(0.7))
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(eventTitle)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .frame(minWidth: 250)
                    
                    HStack {
                        if (icon == "calendar") {
                            // 間隔
                            Text(eventSubtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        } else if (icon == "book") {
                            // 一般學習
                            Text(eventRecurringUnit)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(eventValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(eventUnit)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        } else if (icon == "figure.walk") {
                            // 運動
                            Text(eventSelectType)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(eventRecurringUnit)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(eventValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(eventUnit)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        } else if (icon == "fork.knife") {
                            // 飲食
                            Text(eventSelectType)
                                .foregroundColor(Color.gray)
                            Text(eventRecurringUnit)
                                .foregroundColor(Color.gray)
                            
                            if let preText = dietsPreTextByType[eventSelectType] {
                                Text(preText)
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            } else {
                                Text("少於")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            }
                            Text(eventValue)
                                .foregroundColor(Color.gray)
                            if let primaryUnits = dietsUnitsByType[eventSelectType] {
                                Text(primaryUnits.first!)
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            } else {
                                Text("次")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            }
                        } else {
                            // 作息
                            Text("每日")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if (eventSelectType == "睡眠時長") {
                                Text("睡滿")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(eventValue) 小時")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(eventUnit) 前")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(eventSelectType)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                }
            }
            .padding()
            .background(Color(hex: "#f1ede8"))
            .cornerRadius(15)
            .shadow(color: Color(hex: "#f1ede8").opacity(0.3), radius: 6, x: 0, y: 6)
        }
    }
    
    struct EventRow: View {
        var eventTitle: String
        var eventSubtitle: String
        var icon: String
        
        var body: some View {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.blue.opacity(0.7))
                VStack(alignment: .leading, spacing: 5) {
                    Text(eventTitle)
                        .font(.headline)
                    Text(eventSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let MockData = MockData()
        
        return CalendarView(switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .environmentObject(SportStore())
            .environmentObject(DietStore())
            .environmentObject(MockData)
            .previewLayout(.sizeThatFits)
    }
}
