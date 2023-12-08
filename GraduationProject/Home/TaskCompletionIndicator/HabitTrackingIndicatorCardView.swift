//
//  HabitTrackingIndicatorCardView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/2.
//
import SwiftUI

struct HabitTrackingIndicatorCardView: View {
    @State var indicatorTitle: String = "即將完成的任務"
    @State var completionRate: Double = 0.7
    @State var upcomingTasks: [HabitTask] = [
        HabitTask(name: "完成任務 A"),
        HabitTask(name: "完成任務 B"),
        HabitTask(name: "完成任務 C")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text("習慣追蹤指標")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#574D38"))
                Spacer()
            }

            VStack {
                HStack {
                    Text(indicatorTitle)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(hex: "#545439"))
                    Spacer()
                }
                ProgressBar(value: completionRate, selectedDiets: "")
            }

            List(upcomingTasks) { task in
                Text(task.name)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardStyle()
    }
}

#Preview {
    HabitTrackingIndicatorCardView()
}
