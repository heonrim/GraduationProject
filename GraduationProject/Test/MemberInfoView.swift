//
//  MemberInfoView.swift
//  GraduationProject
//
//  Created by heonrim on 4/7/23.
//

import SwiftUI

struct MemberInfoView: View {
    let memberInfo: MemberInfo
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Image(memberInfo.profileImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding()
                
                Text(memberInfo.name)
                    .font(.title)
                
                Text(memberInfo.bio)
                    .font(.body)
                
                HStack {
                    Text("今日進度")
                    Spacer()
                    Text("\(Int(memberInfo.taskProgress * 100))%")
                }
                ProgressBar(value: memberInfo.taskProgress, selectedDiets: "")
                    .frame(height: 20)
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    Button(action: {
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: 80, height: 40)
                            Text("提醒")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                    })
                    Spacer()
                }
                
                Spacer()
            }
            .navigationBarTitle(Text("成員資訊"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                }) {
                    Image(systemName: "gear")
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}

struct MemberInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let memberInfo = MemberInfo(name: "Jisoo", profileImageName: "IMG_6524", bio: "成為自律的人", taskProgress: 0.5)
        MemberInfoView(memberInfo: memberInfo)
    }
}

struct MemberInfo {
    let name: String
    let profileImageName: String
    let bio: String
    let taskProgress: Double
}
