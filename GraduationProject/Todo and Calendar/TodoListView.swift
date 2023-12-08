//
//  SpacedView.swift
//  SpacedRepetition
//
//  Created by heonrim on 5/1/23.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @AppStorage("uid") private var uid: String = ""
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var hasLoadedData = false
    @State var ReviewChecked0: Bool
    @State var ReviewChecked1: Bool
    @State var ReviewChecked2: Bool
    @State var ReviewChecked3: Bool
    
    var switchViewAction: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                if taskStore.tasks.isEmpty && todoStore.todos.isEmpty && sportStore.sports.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        SectionHeaderView(title: "間隔學習法")
                        ForEach(taskStore.tasks.indices, id: \.self) { index in
                            NavigationLink(destination: SpaceDetailView(task: $taskStore.tasks[index])) {
                                ItemView(title: taskStore.tasks[index].title, description: taskStore.tasks[index].description, date: taskStore.tasks[index].nextReviewDate)
                            }
                        }
                        
                        SectionHeaderView(title: "一般學習法")
                        ForEach(todoStore.todos.indices, id: \.self) { index in
                            NavigationLink(destination: StudyDetailView(todo: $todoStore.todos[index])) {
                                ItemView(title: todoStore.todos[index].title, description: todoStore.todos[index].description, date: todoStore.todos[index].startDateTime)
                            }
                        }
                        
                        SectionHeaderView(title: "運動")
                        ForEach(sportStore.sports.indices, id: \.self) { index in
                            NavigationLink(destination: DetailSportView(sport: $sportStore.sports[index])) {
                                ItemView(title: sportStore.sports[index].title, description: sportStore.sports[index].description, date: sportStore.sports[index].startDateTime)
                            }
                        }
                        SectionHeaderView(title: "飲食")
                        ForEach(dietStore.diets.indices, id: \.self) { index in
                            NavigationLink(destination: DietDetailView(diet: $dietStore.diets[index])) {
                                ItemView(title: dietStore.diets[index].title, description: dietStore.diets[index].description, date: dietStore.diets[index].startDateTime)
                            }
                        }
                        SectionHeaderView(title: "作息")
                        ForEach(routineStore.routines.indices, id: \.self) { index in
                            NavigationLink(destination: RoutineDetailView(routine: $routineStore.routines[index])) {
                                ItemView(title: routineStore.routines[index].title, description: routineStore.routines[index].description, date: routineStore.routines[index].startDateTime)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("待辦事項", displayMode: .inline)
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
    }
    
    private func EmptyStateView() -> some View {
        Text("尚未新增事項")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func SectionHeaderView(title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func ItemView(title: String, description: String, date: Date, icon: String = "calendar") -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.blue.opacity(0.7))
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 250)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Start time: \(formattedDate(date))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
    
    
    var leadingBarItem: some View {
        Button(action: switchViewAction) {
            Image(systemName: "calendar")
                .imageScale(.large)
                .foregroundColor(.primary)
        }
    }
    
    var trailingBarItem: some View {
        Button(action: { showingActionSheet = true }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(.primary)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}

struct SpacedView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false, switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .environmentObject(SportStore())
    }
}
