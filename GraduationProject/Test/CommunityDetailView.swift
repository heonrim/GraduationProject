//
//  CommunityDetailView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/27.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CommunityDetailView: View {
    let community: Community
    @State private var selectedTab = 0
    let tabs = ["公告", "日常挑戰", "成員名單", "討論區"]
    let challenges = [
        "今日做10分鐘冥想",
        "讀一章書",
        "做20個伏地挺身"
    ]
    @State private var scrollOffset: CGFloat = 0.0
    @State private var headerHeight: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                if scrollOffset < headerHeight {
                    CommunityDetailHeader(community: community)
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
                        })
                }
                
                Picker("", selection: $selectedTab) {
                    ForEach(0..<tabs.count) { index in
                        Text(self.tabs[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .background(Color.white)
                .offset(y: -min(headerHeight, scrollOffset))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        if selectedTab == 1 {
                            ForEach(challenges, id: \.self) { challenge in
                                Text(challenge)
                            }
                        }
                    }
                    .padding(.top)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ViewOffsetKey.self) { self.scrollOffset = $0 }
                .onPreferenceChange(ViewHeightKey.self) { self.headerHeight = $0 }
            }
            .navigationBarTitle(community.communityName, displayMode: .inline)
        }
    }
}

struct CommunityDetailHeader: View {
    let community: Community
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("community_picture")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(radius: 10)
                .padding(.top)
            
            Text(community.communityName)
                .font(.title)
                .bold()
            
            Text(community.communityDescription)
                .padding(.top, 8)
        }
        .padding()
    }
}


struct CommunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCommunity = Community(id: 1, communityName: "每日冥想", communityDescription: "專注於冥想的社群", communityCategory: 1, image: "GP1",isMember: "true")
        CommunityDetailView(community: sampleCommunity)
    }
}
