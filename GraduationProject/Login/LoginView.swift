//
//  LoginView.swift
//  GraduationProject
//
//  Created by heonrim on 5/23/23.
//

import SwiftUI
import SwiftSMTP
import FirebaseAuth
import GoogleSignIn
import Firebase

struct LoginView: View {
    var body: some View {
        
        ZStack{
            
            // LinearGradient: 用來創建漸層顏色的視圖，這裡創建了一個由三種不同顏色組成的漸層背景
            // startPoint 和 endPoint: 用於指定漸層的起點和終點，這裡設置為 .top 和 .bottom，表示漸層從頂部到底部
            // edgesIgnoringSafeArea(.all): 這個修飾器用於忽略安全區域，讓漸層顏色佔滿整個螢幕
            LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            // 根據螢幕高度的不同，顯示不同的內容。
            if UIScreen.main.bounds.height > 800{
                LoginHome()
            } else{
                // 當螢幕高度小於 800 時，使用這個捲動視圖來顯示
                ScrollView(.vertical, showsIndicators: false) {
                    LoginHome()
                }
            }
        }
    }
}

struct LoginHome : View {
    
    @State var index = 0
    @State public var errorMessage1 = ""
    @State public var errorMessage2 = ""

    var body : some View{
        
        VStack{
            Image("icon-remove")
                .resizable()
                .frame(width: 180, height: 180)
                .aspectRatio(contentMode: .fit)
            HStack{
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                        self.index = 0
                    }
                }) {
                    Text("登入")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }.background(self.index == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                        self.index = 1
                    }
                }) {
                    Text("註冊")
                        .foregroundColor(self.index == 1 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }.background(self.index == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }.background(Color.black.opacity(0.1))
                .clipShape(Capsule())
                .padding(.top, 25)
            
            if self.index == 0{
                Login(errorMessage1: $errorMessage1)
            }
            else{
                SignUp(errorMessage2: $errorMessage2)
            }
            
            // 建立提示錯誤訊息
            Text(errorMessage1)
                .foregroundColor(.red)
            Text(errorMessage2)
                .foregroundColor(.red)
            
            if self.index == 0{
                Button(action: {
                    
                }) {
                    Text("忘記密碼?")
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
            }
            
            GoogleSigninBtn {
                FireAuth.share.signinWithGoogle(presenting: getRootViewController()) { error in
                    print("GoogleLoginERROR: \(String(describing: error))")
                }
            }
            HStack(spacing: 15){
            }
            .padding(.top, 10)
        }
        .padding()
        .onChange(of: index) { newValue in
            // 切換到註冊頁面時，重置錯誤訊息
            errorMessage1 = ""
            errorMessage2 = ""
        }
    }
}

struct Login : View {
    
    @State var mail = ""
    @State var pass = ""
//    @State private var errorMessage = ""
    @Binding var errorMessage1: String
    @State var isPasswordVisible = false
    struct UserData: Decodable {
        var id: String
        var email: String
        var message: String
    }
    
    var body : some View{
        
        VStack{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    TextField("輸入電子信箱", text: self.$mail)
                }
                .padding(.vertical, 20)
                .onChange(of: mail) { newValue in
                    if !errorMessage1.isEmpty {
                        if (mail.isEmpty || pass.isEmpty) {
                            errorMessage1 = "請確認空格內都已輸入資料"
                        } else {
                            errorMessage1 = ""
                        }
                    }
                }
        
                Divider()

                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if isPasswordVisible {
                        TextField("輸入密碼", text: self.$pass)
                    } else {
                        SecureField("輸入密碼", text: self.$pass)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, 20)
                .onChange(of: pass) { newValue in
                    if !errorMessage1.isEmpty {
                        if (mail.isEmpty || pass.isEmpty) {
                            errorMessage1 = "請確認空格內都已輸入資料"
                        } else {
                            errorMessage1 = ""
                        }
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            Button(action: {
                // 我要輸入登入的function
                // 登入成功後要改成true
                if mail.isEmpty || pass.isEmpty {
                    errorMessage1 = "請確認帳號密碼都有輸入"
                } else {
                    login{_ in }
                }
            }) {
                Text("登入")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
            }.background(
                // 創建一個線性漸層背景
                LinearGradient(gradient: .init(colors: [Color("Color2"),Color("Color1"),Color("Color")]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
//            如果為空的話按鈕不能按
//            .disabled(mail.isEmpty || pass.isEmpty)
        }
    }
    
    func login(completion: @escaping (String) -> Void) {
        let body = ["email": mail, "password": pass]
        phpUrl(php: "login" ,type: "account",body:body, store: nil){ message in
            // 在此处调用回调闭包，将 messenge 值传递给调用者
            print("登入回傳：\(String(describing: message["message"]))")
            if message["message"] == "Invalid password" {
                errorMessage1 = "密碼輸入錯誤"
            } else if message["message"] == "No such account" {
                errorMessage1 = "帳號輸入錯誤"
            } else if message["message"] != "User registerGmail successfully" ||  message["message"] != "User login successfully" {
                errorMessage1 = "登入錯誤 請聯繫管理員"
            }
            completion(message["message"]!)
        }
    }
}

struct SignUp : View {
    
    @State var mail = ""
    @State var pass = ""
    @State var repass = ""
    @State private var verify = ""
    @State var isPasswordVisible1 = false
    @State var isPasswordVisible2 = false
    @Binding var errorMessage2: String
    @State var set_date: Date = Date()
    @State var Set_date: String = ""
    @State private var isShowingVerifyRegister = false
    @State private var isSendingMail = false

    struct UserData : Decodable {
        var userId: String?
        var email: String
        var password: String
        var create_at: String
        var message: String
    }
    
    var body : some View{
        
        VStack{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("輸入電子信箱", text: self.$mail)
                }
                .padding(.vertical, 20)
                .onChange(of: mail) { newValue in
                    if !errorMessage2.isEmpty {
                        if (mail.isEmpty || pass.isEmpty || repass.isEmpty) {
                            errorMessage2 = "請確認空格內都已輸入資料"
                        } else {
                            errorMessage2 = ""
                        }
                    }
                }
                
                Divider()
                
                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if isPasswordVisible1 {
                        TextField("輸入密碼", text: self.$pass)
                    } else {
                        SecureField("輸入密碼", text: self.$pass)
                    }
                    Button(action: {
                        isPasswordVisible1.toggle()
                    }) {
                        Image(systemName: isPasswordVisible1 ? "eye.slash" : "eye")
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, 20)
                .onChange(of: pass) { newValue in
                    if !errorMessage2.isEmpty {
                        if (mail.isEmpty || pass.isEmpty || repass.isEmpty) {
                            errorMessage2 = "請確認空格內都已輸入資料"
                        } else {
                            errorMessage2 = ""
                        }
                    }
                }
                
                Divider()
                
                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    // yun 改
                    if isPasswordVisible2 {
                        TextField("再次輸入密碼", text: self.$repass)
                    } else {
                        SecureField("再次輸入密碼", text: self.$repass)
                    }
                    Button(action: {
                        isPasswordVisible2.toggle()
                    }) {
                        Image(systemName: isPasswordVisible2 ? "eye.slash" : "eye")
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, 20)
                .onChange(of: repass) { newValue in
                    if (mail.isEmpty || pass.isEmpty || repass.isEmpty) {
                        errorMessage2 = "請確認空格內都已輸入資料"
                    } else {
                        if (pass != repass) {
                            errorMessage2 = "密碼不一致 請重新輸入"
                        } else {
                            errorMessage2 = "" // 清除錯誤訊息
                        }
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            Button(action: {
                // 我要輸入註冊的function
                if mail.isEmpty || pass.isEmpty || repass.isEmpty {
                    errorMessage2 = "請確認帳號密碼都有輸入"
                } else {
                    if !isSendingMail { // 避免重複發送郵件
                        sendEmail(verify: verify,mail: mail) { v,m in
                            if (m == "Success") {
                                isSendingMail = true
                                verify = v
                                print("loginVerify - \(m)")
                            } else {
                                isSendingMail = false
                                print("regiest - \(m)")
                            }
                        }
                    }
                    isShowingVerifyRegister = true
                }
            }) {
                Text("註冊")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
            }.background(
                LinearGradient(gradient: .init(colors: [Color("Color2"),Color("Color1"),Color("Color")]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
            .sheet(isPresented: $isShowingVerifyRegister) {
                verifyRegister(verify: $verify, mail: $mail, pass: $pass, isSendingMail: $isSendingMail)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
