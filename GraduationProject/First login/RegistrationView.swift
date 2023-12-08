//
//  RegistrationView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/17.
//

import SwiftUI

struct RegistrationView: View {
    @AppStorage("userName") private var userName:String = ""
    @State private var registerStep = 0
    @State private var nickname: String = ""
    @State private var goal: String = ""
    @State private var navigateToStory: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Image(registerStep == 0 ? "Registration1" : "Registration2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    if registerStep == 0 {
                        Text("你希望我們怎麼稱呼你？")
                            .font(.headline)

                        TextField("暱稱", text: $nickname)
                            .padding(10)
                            .font(.title2)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                            .frame(maxWidth: 300)

                        Button(action: {
                            withAnimation {
                                registerStep = 1
                                register{_ in }
                            }
                        }) {
                            Text("下一步")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Text("分享你的第一個目標是什麼？")
                            .font(.headline)

                        TextField("我的目標是...", text: $goal)
                            .padding(10)
                            .font(.title2)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                            .frame(maxWidth: 300)

                        Button(action: {
                            print("Registration Completed!")
                            navigateToStory = true
                            register{_ in }
                        }) {
                            Text("完成註冊")
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .background(
                            NavigationLink("", destination: IntroAnimationView()
                                .navigationBarBackButtonHidden(true)
                                .interactiveDismissDisabled(true)
                            , isActive: $navigateToStory)
                            .hidden()
                        )
                    }
                    Spacer().frame(height: 100)
                }
                .padding(.all, 20)
                .cornerRadius(10)
                .transition(.slide)
                .animation(.easeInOut(duration: 1.0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear() {
            if userName == "" {
                registerStep = 0
            } else {
                registerStep = 1
            }
        }
    }
    
    func register(completion: @escaping (String) -> Void) {
        var body: [String : Any] = [:]
        
        if navigateToStory {
            body = ["userDescription": goal]
        } else {
            body = ["userName": nickname]
        }

        phpUrl(php: "register" ,type: "account",body:body, store: nil){ message in
            print("註冊0回傳：\(String(describing: message["message"]))")
            completion(message["message"]!)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var registerStep = 0

        var body: some View {
            RegistrationView()
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
