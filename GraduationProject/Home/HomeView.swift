//
//  HomeView.swift
//  GraduationProject
//
//  Created by heonrim on 8/3/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @State private var showQuoteView: Bool = false
    @Binding var tabBarHidden: Bool
    @AppStorage("image") private var selectedCoverPhotoName: String = "appstore"
    @AppStorage("userName") private var userName: String = "我習慣了"
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 20) {

                    HStack {
                            Image("icon-remove")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))

                            VStack(alignment: .leading) {
                                Text("\(getTimeOfDay()), \(userName)")
                                    .font(.system(size: 22, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(hex: "#96616D"))
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading) {
                            Text("只要是自己的目標，努力都有價值")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(Color(hex: "757d89"))
                        }
                        .padding(.horizontal)

                    
                    NavigationLink(destination: QuoteView()) {
                        QuoteCardView().cardStyle()
                    }.clearNavigationLinkStyle()
                    
                    NavigationLink(destination: TodayTasksView()) {
                        TodayTodoCardView()
                            .cardStyle()
                    }
                    .clearNavigationLinkStyle()
                    
                    NavigationLink(destination: HabitTrackingIndicatorView()) {
                        HabitTrackingIndicatorCardView()
                            .cardStyle()
                    }
                    .clearNavigationLinkStyle()
                    
                    NavigationLink(destination: AchievementsPageView()) {
                        AchievementCardView(achievement: Achievement(title: "首次之旅", description: "第一次添加習慣", achieved: true, imageName: "plus.circle.fill"))
                            .cardStyle()
                    }
                    .clearNavigationLinkStyle()
                    
                    
                    let sampleActivities = [
                        CommunityActivity(userName: "王小明", groupName: "學習小組", habitCategory: "學習", timeFrame: "今日"),
                        CommunityActivity(userName: "李小花", groupName: "運動俱樂部", habitCategory: "運動", timeFrame: "本週"),
                    ]

                    CommunityCardScrollView(activities: sampleActivities)

                }
                .padding()
            }
            .background(
                ZStack {
                    LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                    
                    GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                    }
                }
            )
                        .navigationBarTitleDisplayMode(.inline)
            .onPreferenceChange(ViewOffsetKey.self) { offset in
                if offset > 10 && !tabBarHidden {
                    withAnimation {
                        tabBarHidden = true
                    }
                } else if offset < 10 && tabBarHidden {
                    withAnimation {
                        tabBarHidden = false
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: tabBarHidden) { newValue in
            print("TabBar hidden status: \(newValue)")
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension View {
    func cardStyle() -> some View {
        self.padding(.all, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.4))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            )
    }
}

struct ClearNavigationLinkStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
    }
}

extension View {
    func clearNavigationLinkStyle() -> some View {
        modifier(ClearNavigationLinkStyle())
    }
}

func getTimeOfDay() -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 6..<12 : return "早安"
    case 12..<17 : return "午安"
    case 17..<21 : return "晚安"
    default: return "要注意休息喔"
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var mockTabBarHidden = false
    
    static var previews: some View {
        NavigationView {
            HomeView(tabBarHidden: $mockTabBarHidden)
                .environmentObject(TaskStore())
                .environmentObject(TodoStore())
        }
    }
}
