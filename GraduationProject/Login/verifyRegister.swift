//
//  verifyRegister.swift
//  smtp
//
//  Created by 呂沄 on 2023/7/12.
//

import SwiftUI
import SwiftSMTP

struct verifyRegister: View {
    
    var aViewInstance = ContentView()
    
    @Binding var verify :String
    @Binding var mail :String
    @Binding var pass :String
    @Binding var isSendingMail :Bool
    @State private var isButtonEnabled = false // 控制按钮是否可用的状态变量
    @State var set_date: Date = Date()
    @State var Set_date: String = ""
    @State var Verify = ""
    @State var messenge = ""
    //    @State var timeRemaining = 300
    @State var timeRemaining = 40
    @State var verificationCode = ""
    @State var verifyNumber = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 180)
                
                Text("驗證帳號")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Remaining Time
                Text("剩餘時間：\(timeRemaining / 60)分 \(timeRemaining % 60)秒")
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
                
                    .font(.subheadline)
                    .padding(.all, 15)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(15)
                
                // Verification Code Input Field
                VStack(alignment: .leading) {
                    Text("您的驗證碼：")
                        .font(.caption)
                        .foregroundColor(.white)
                    TextField("驗證碼", text: $Verify)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 10)
                }
                .padding(.horizontal, 30)
                
                // Verification Button
                Button {
                    print("verify - 進行驗證中")
                    doVerify()
                } label: {
                    Text("進行驗證")
                        .font(.headline)
                        .padding(.horizontal, 80)
                        .padding(.vertical, 15)
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 15)
                
                // Resend Verification Code Button
                Button {
                    print("verify - 再次發送驗證碼")
                    timeRemaining = 40
                    sendEmail(verify: verify,mail: mail) { v,m in
                        verify = "0"
                        if (m == "Success") {
                            verificationCode = v
                            print("loginVerify - \(m)")
                        } else {
                            print("regiest - \(m)")
                        }
                    }
                } label: {
                    Text("重新發送驗證碼")
                        .font(.callout)
                        .underline()
                        .foregroundColor(Color.blue)
                }
                .disabled(timeRemaining != 0)
                .opacity(timeRemaining != 0 ? 0.5 : 1.0) // 设置按钮的不透明度
                .padding(.top, 10)
                
                // Error Message
                Text(messenge)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding(.top, 50)
        }
        .onDisappear() {
            isSendingMail = false
        }
    }
    
    func doVerify() {
        // 如果上個畫面的驗證碼還存在的話使用上個畫面的驗證碼去判斷使用者是否輸入錯誤
        if (verify != "0"){
            print("我是測試：\(verify)")
            verifyNumber = String(verify)
        } else {
            // 如果上個畫面的驗證碼為0使用新的驗證碼去判斷
            verifyNumber = verificationCode
        }
        print("verify - 驗證碼為：\(verifyNumber)")
        print("verify - 使用者輸入為：\(Verify)")
        if (timeRemaining == 0) {
            print("verify - 時效已過，請重新再驗證一次")
            messenge = "時效已過，請重新再驗證一次"
        } else {
            if (Verify == verifyNumber) {
                // 將使用者資料加入資料庫
                print("verify - 驗證碼輸入正確")
                messenge = "使用者輸入正確"
                register{_ in }
            } else {
                print("verify - 驗證碼輸輸入錯誤，請重新輸入")
                messenge = "驗證碼輸輸入錯誤，請重新輸入"
            }
        }
    }
    
    func register(completion: @escaping (String) -> Void) {
        Set_date = formattedDate(set_date)
        let body = ["email": mail, "password": pass, "create_at": Set_date]
        print("body:\(body)")
        phpUrl(php: "register" , type: "account", body: body, store: nil) { message in
            print("註冊回傳：\(String(describing: message["message"]))")
            if message["message"] == "email is registered" {
                messenge = "電子郵件已註冊過"
            } else if message["message"] != "User registered successfully" {
                messenge = "註冊失敗 請聯繫管理員"
            }
            completion(message["message"]!)
        }
    }
}

struct verifyRegister_Previews: PreviewProvider {
    static var previews: some View {
        @State var verify = "00000000"
        @State var mail: String = "Email"
        @State var pass: String = "password"
        @State var isSendingMail = false
        NavigationView {
            verifyRegister(verify: $verify, mail: $mail,pass:$pass, isSendingMail:$isSendingMail)
        }
    }
}
