//
//  CommunityCardView.swift
//  GraduationProject
//
//  Created by OpenAI on 10/30/23.
//

import SwiftUI

struct CommunityActivity: Identifiable {
    var id = UUID()
    var userName: String
    var groupName: String
    var habitCategory: String
    var timeFrame: String
}

struct CommunityCardView: View {
    var activity: CommunityActivity
    
    private var habitIcon: String {
        switch activity.habitCategory {
        case "學習": return "book.fill"
        case "運動": return "sportscourt.fill"
        case "作息": return "bed.double.fill"
        case "飲食": return "fork.knife"
        default: return "questionmark"
        }
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: habitIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(activity.userName)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#574D38"))
                
                Text(activity.groupName)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#545439"))
                
                Text("完成了所有\(activity.timeFrame)的\(activity.habitCategory)任務")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#545439"))
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .cardStyle()
    }
}

struct CommunityCardScrollView: View {
    var activities: [CommunityActivity] = [
        CommunityActivity(userName: "王小明", groupName: "學習小組", habitCategory: "學習", timeFrame: "今日"),
        CommunityActivity(userName: "李小花", groupName: "運動俱樂部", habitCategory: "運動", timeFrame: "本週"),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(activities) { activity in
                    CommunityCardView(activity: activity)
                }
            }
            .padding()
        }
    }
}

struct CommunityCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityCardScrollView()
    }
}
