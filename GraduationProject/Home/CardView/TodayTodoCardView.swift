//
//  TodayTodoCardView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

extension Task {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self.nextReviewDate)
    }
}

struct TodayTodoCardView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @EnvironmentObject var tickerStore: TickerStore
    @EnvironmentObject var communityStore: CommunityStore
    // Helper function to format date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("今日待辦事項")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#5D3E63"))
                Spacer()
            }
            
            HStack {
                Text("間隔學習法")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#C15D63"))
                Spacer()
            }
            
            ForEach(taskStore.tasksForDate(Date()), id: \.id) { task in
                HStack(alignment: .top) {
                    Text(task.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(task.description)
                                            .font(.caption)
                }
            }
            
            HStack {
                Text("一般學習")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#C15D63"))
                Spacer()
            }
            
            ForEach(todoStore.todosForDate(Date()), id: \.id) { todo in
                HStack(alignment: .top) {
                    Text(todo.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(todo.description)
                                            .font(.caption)
                }
            }
            HStack {
                Text("運動")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#C15D63"))
                Spacer()
            }
            
            ForEach(sportStore.sportsForDate(Date()), id: \.id) { todo in
                HStack(alignment: .top) {
                    Text(todo.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(todo.description)
                                            .font(.caption)
                }
            }
            
            HStack {
                Text("飲食")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#C15D63"))
                Spacer()
            }
            
            ForEach(dietStore.dietForDate(Date()), id: \.id) { todo in
                HStack(alignment: .top) {
                    Text(todo.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(todo.description)
                                            .font(.caption)
                }
            }
            HStack {
                Text("作息")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#C15D63"))
                Spacer()
            }
            
            ForEach(routineStore.routineForDate(Date()), id: \.id) { todo in
                HStack(alignment: .top) {
                    Text(todo.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(todo.description)
                                            .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardStyle()
    }
}


struct TodayTodoCardView_Previews: PreviewProvider {
    static var previews: some View {
        TodayTodoCardView()
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
    }
}
