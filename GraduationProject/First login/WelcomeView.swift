//
//  WelcomeView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/3.
//

import SwiftUI

struct WelcomeView: View {
    @State private var tabBarHidden = true
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    @State private var buttonScale: CGFloat = 1.0
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @EnvironmentObject var dietStore: DietStore
    @EnvironmentObject var routineStore: RoutineStore
    @EnvironmentObject var tickerStore: TickerStore
    @EnvironmentObject var communityStore: CommunityStore
    @EnvironmentObject var tabBarSettings: TabBarSettings
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                Text("歡迎使用「我習慣了」!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .cornerRadius(10)
                    .shadow(radius: 10)

                Text("你已經讀到了小明的成功故事。現在，是時候開始你的轉變之旅。")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 20)
                
                Button(action: {
                    register{_ in }
                }, label: {
                    Text("開始使用")
                })
                    .font(.title2)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .padding([.leading, .trailing], 20)
                    .scaleEffect(buttonScale)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                            buttonScale = 1.1
                        }
                    }

                Spacer()
            }
            .offset(y: offset)
            .onAppear() {
                withAnimation {
                    offset = 0
                }
            }
        }
        .navigationBarHidden(true)
    }
    func register(completion: @escaping (String) -> Void) {

        let body : [String : Any] = [:]
        phpUrl(php: "register" ,type: "account",body:body, store: nil){ message in
            print("註冊5回傳：\(String(describing: message["message"]))")
            completion(message["message"]!)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
