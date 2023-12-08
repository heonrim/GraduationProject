//
//  AchievementCardView.swift
//  GraduationProject
//
//  Created by heonrim on 9/5/23.
//

import SwiftUI

struct AchievementCardView: View {
    var achievement: Achievement

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#574D38"))
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#545439"))
                
                HStack {
                    Spacer()
                    Image(systemName: achievement.achieved ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(achievement.achieved ? .yellow : .gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cardStyle()
        }
    }
}

struct AchievementCardView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementCardView(achievement: Achievement(title: "成就", description: "多元探索者", achieved: true, imageName: "plus.circle.fill"))
    }
}
