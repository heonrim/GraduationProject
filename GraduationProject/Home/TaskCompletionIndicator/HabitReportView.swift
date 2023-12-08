////
////  HabitReportView.swift
////  GraduationProject
////
////  Created by heonrim on 2023/9/20.
////
//
//import SwiftUI
//
//struct HabitReportView: View {
//    // 基本任務型別
//    struct Task: Identifiable {
//        let id = UUID()
//        let name: String
//        let completionRates: [Double]
//    }
//    
//    // 分類型別，包含一組任務
//    struct Category: Identifiable {
//        let id = UUID()
//        let name: String
//        let tasks: [Task]
//    }
//    
//    // 範例數據
//    let categories: [Category] = [
//        Category(name: "一般學習", tasks: [
//            Task(name: "數學", completionRates: [1.0, 0.9, 0.7, 1.0, 0.8, 0.9, 0.7]),
//            Task(name: "物理", completionRates: [0.8, 0.7, 1.0, 0.6, 1.0, 0.7, 0.9]),
//            Task(name: "化學", completionRates: [0.6, 0.7, 0.8, 0.8, 0.7, 0.6, 0.7])
//        ]),
//        Category(name: "間隔學習", tasks: [
//            Task(name: "單詞記憶", completionRates: [0.9, 1.0, 0.9, 0.9, 1.0, 1.0, 0.8]),
//            Task(name: "公式複習", completionRates: [0.7, 0.6, 0.8, 0.7, 0.6, 0.7, 0.8])
//        ]),
//        Category(name: "運動", tasks: [
//            Task(name: "慢跑", completionRates: [1.0, 1.0, 0.9, 0.8, 0.9, 1.0, 1.0]),
//            Task(name: "瑜伽", completionRates: [0.8, 0.8, 0.7, 0.8, 0.9, 0.7, 0.8])
//        ]),
//        Category(name: "飲食", tasks: [
//            Task(name: "健康早餐", completionRates: [1.0, 1.0, 1.0, 1.0, 0.9, 1.0, 1.0]),
//            Task(name: "不吃垃圾食品", completionRates: [0.7, 0.6, 0.7, 0.6, 0.6, 0.7, 0.6])
//        ]),
//        Category(name: "作息", tasks: [
//            Task(name: "10點前睡覺", completionRates: [0.9, 1.0, 0.9, 0.8, 0.9, 0.9, 1.0]),
//            Task(name: "6點起床", completionRates: [0.8, 0.8, 0.8, 0.7, 0.8, 0.9, 0.8])
//        ])
//    ]
//    
//    
//    let primaryColor = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
//        let secondaryColor = Color(#colorLiteral(red: 0.5, green: 0.6, blue: 0.7, alpha: 1))
//        let cardBackgroundColor = Color.white.opacity(0.9)
//        let backgroundColor = Color(#colorLiteral(red: 0.94, green: 0.96, blue: 0.98, alpha: 1))
//
//        var body: some View {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    ForEach(categories) { category in
//                        Text(category.name)
//                            .font(.system(size: 34, weight: .bold, design: .rounded))
//                            .foregroundColor(primaryColor)
//                            .padding(.top, 25)
//                            .padding(.leading, 25)
//                            .padding(.bottom, 10)
//                        
//                        ForEach(category.tasks) { task in
//                            HStack {
//                                Text(task.name)
//                                    .font(.system(size: 20, weight: .medium, design: .rounded))
//                                    .padding(.leading, 25)
//                                    .foregroundColor(primaryColor)
//                                    .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
//                                
//                                Spacer()
//                                
//                                HStack(spacing: 12) {
//                                    ForEach(task.completionRates, id: \.self) { rate in
//                                        ProgressBar(completionRate: rate)
//                                            .animation(.easeInOut(duration: 0.7))
//                                    }
//                                }
//                                .padding(.trailing, 25)
//                            }
//                            .padding(15)
//                            .background(cardBackgroundColor)
//                            .cornerRadius(20)
//                            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 10)
//                            .padding(.leading, 20)
//                            .padding(.trailing, 20)
//                            .padding(.bottom, 10)
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//            }
//            .background(backgroundColor)
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//
//    struct ProgressBar: View {
//        var completionRate: Double
//        
//        var body: some View {
//            Rectangle()
//                .fill(completionRate > 0.7 ? Color.green : (completionRate > 0.4 ? Color.orange : Color.red))
//                .frame(width: 20, height: 20 * CGFloat(completionRate))
//                .cornerRadius(6)
//                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2), lineWidth: 1))
//        }
//    }
//
//struct HabitReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitReportView()
//    }
//}
