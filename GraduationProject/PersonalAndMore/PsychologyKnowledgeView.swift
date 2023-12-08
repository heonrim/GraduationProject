//
//  PsychologyKnowledgeView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI

struct PsychologyKnowledgeView: View {
    @State private var knowledgeIndex = 0
    
    let knowledgeData: [Knowledge] = [
        Knowledge(title: "自我效能感", description: "一個人對自己能夠完成某項任務的信心程度。", imageName: "person.fill"),
            Knowledge(title: "意志力", description: "意志力是抵抗誘惑並實現長期目標的能力。它可以通過練習來增強。", imageName: "bolt.fill"),
            Knowledge(title: "自我控制", description: "自我控制是抵抗誘惑、管理情緒並做出明智決策的能力。它有助於達成個人和職業目標。", imageName: "slider.horizontal.3"),
            Knowledge(title: "習慣養成", description: "習慣是反覆執行的行為，通常需要約21天形成。建立良好習慣可以提高生活品質。", imageName: "list.bullet"),
            Knowledge(title: "誘惑管理", description: "誘惑是意志力的挑戰。學會管理誘惑，例如避免誘惑源，有助於保持自我控制。", imageName: "hand.raised.fill"),
            Knowledge(title: "目標設定", description: "設定具體、可衡量、可達成的目標是實現自我控制和意志力的重要一步。", imageName: "flag.fill"),
            Knowledge(title: "社交支持", description: "與朋友、家人或同事分享目標並互相支持可以增強自我控制和習慣養成的成功率。", imageName: "person.2.fill")
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("心理學小知識")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 50)
                    .foregroundColor(Color(hex: "#A8A39D"))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack {
                        Image(systemName: knowledgeData[knowledgeIndex].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.top, 30)
                            .foregroundColor(Color(hex: "#A8A39D"))
                        
                        Text(knowledgeData[knowledgeIndex].title)
                            .font(.title2)
                            .padding(.top, 20)
                            .foregroundColor(Color(hex: "#A8A39D"))
                        
                        Text(knowledgeData[knowledgeIndex].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(Color(hex: "#92908D"))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        if knowledgeIndex > 0 {
                            knowledgeIndex -= 1
                        }
                    }, label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color(hex: "#A8A39D"))
                            .cornerRadius(20)
                    })
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        if knowledgeIndex < knowledgeData.count - 1 {
                            knowledgeIndex += 1
                        }
                    }, label: {
                        Image(systemName: "arrow.right")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color(hex: "#A8A39D"))
                            .cornerRadius(20)
                    })
                    .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
                
            }
        }
    }
}

struct Knowledge {
    let title: String
    let description: String
    let imageName: String
}

struct PsychologyKnowledgeView_Previews: PreviewProvider {
    static var previews: some View {
        PsychologyKnowledgeView()
    }
}
