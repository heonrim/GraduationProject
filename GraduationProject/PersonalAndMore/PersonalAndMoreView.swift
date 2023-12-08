//
//  PersonalAndMoreView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI

struct PersonalAndMoreView: View {
    
    @AppStorage("userName") private var userName: String = "我習慣了"
    @AppStorage("userDescription") private var userDescription: String = "這是我的習慣養成之旅，與我一起進步吧!"
    @AppStorage("image") private var selectedCoverPhotoName: String = "appstore"
    
    @EnvironmentObject var tickerStore: TickerStore
    @State private var showingSheet = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        Image(selectedCoverPhotoName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 10)
                        
                        Text(userName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(userDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        Button("查看和編輯個人資料") {
                           showingSheet.toggle()
                       }
                        .font(.footnote)
                        .foregroundColor(.blue)
                       .sheet(isPresented: $showingSheet) {
                           ProfileEditView(username: $userName,userDescription: $userDescription,selectedCoverPhotoName: $selectedCoverPhotoName)
                               .presentationDetents([ .large, .large])
                       }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(getFeatures(), id: \.title) { feature in
                            FeatureCard(feature: feature)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all))
            }
            .background(Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all))
        }
    }

    func getFeatures() -> [Feature] {
        return [
            Feature(title: "心理學小知識", imageName: "brain", backgroundColor: Color(hex: "#A8A39D"), destination: AnyView(PsychologyKnowledgeView())),
            Feature(title: "心理學測試", imageName: "pencil.and.ellipsis.rectangle", backgroundColor: Color(hex: "#92908D"), destination: AnyView(PsychologyTestView().environmentObject(TickerStore()))), // 修改名稱和SF Symbol
            Feature(title: "推薦閱讀", imageName: "book", backgroundColor: Color(hex: "#A9A49B"), destination: AnyView(RecommendedReadingView())),
            Feature(title: "獎勵兌換", imageName: "gift", backgroundColor: Color(hex: "#BFBAB6"), destination: AnyView(TickerView().environmentObject(tickerStore))),
            Feature(title: "正念中心", imageName: "leaf.arrow.circlepath", backgroundColor: Color(hex: "#BFC8A1"), destination: AnyView(MindfulnessHubView())),
            Feature(title: "設定", imageName: "gear", backgroundColor: Color(hex: "#BEB9B5"), destination: AnyView(SettingsView().environmentObject(TickerStore())))
        ]
    }
}

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let backgroundColor: Color
    let destination: AnyView
}

struct FeatureCard: View {
    let feature: Feature

    var body: some View {
        NavigationLink(destination: feature.destination) {
            VStack(spacing: 10) {
                Image(systemName: feature.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)

                Text(feature.title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width: 150, height: 150)
            .background(feature.backgroundColor)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}

struct PersonalAndMoreView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAndMoreView()
    }
}
