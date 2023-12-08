import Foundation
import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn
import SafariServices

struct TickerView: View {
    @EnvironmentObject var tickerStore: TickerStore
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "e0e0e0")
                                    .edgesIgnoringSafeArea(.all)
            VStack {
                if tickerStore.tickers.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(tickerStore.tickers) { ticker in
                            TickerRow(ticker: ticker)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        }.onAppear() {
            print("tickerList: \(tickerStore.tickers)")
        }
        .navigationBarTitle("票券列表", displayMode: .inline)
    }
    
    private func EmptyStateView() -> some View {
            Text("尚未獲得票卷")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color("#6e707a"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    
    func openSafariView() {
        tickerStore.clearTodos()
        guard let url = URL(string: "http://163.17.136.73/web_login.aspx") else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let mainWindow = windowScene.windows.first {
                mainWindow.rootViewController?.present(safariViewController, animated: true, completion: nil)
            }
        }
    }
}

struct PostData: Encodable {
    var userID: String
    var TickerID: String
}

struct TickerRow: View {
    @EnvironmentObject var tickerStore: TickerStore
    var ticker: Ticker
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("uid") private var uid:String = ""
    @AppStorage("password") private var password:String = ""
    @State var ticker_id: String = ""
    @State var verify: String = ""
    var body: some View {
        HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("名稱： \(ticker.name)")
                            .font(.headline)
                            .foregroundColor(Color(hex:"#6e707a"))
                        Text("id： \(ticker.id)")
                                            .foregroundColor(Color(hex: "8a8b8e"))
                                        Text("截止日期： \(formattedDate(ticker.deadline))")
                                            .foregroundColor(Color(hex: "8a8b8e"))
                                        Text("兌換時間： \(ticker.exchage)")
                                            .foregroundColor(Color(hex: "8a8b8e"))
                    }
                    .padding()
                                .background(CouponBackground())
                                .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color(hex: "#7d6e83"), lineWidth: 2)
                                            )
            Spacer()
            Button(action: {
                postTicker { verify, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else if let verify = verify {
                        openSafariView(verify)
                    }
                }
                
            }){
                Image(systemName: "gift.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(hex: "7d6e83"))
            }
            .buttonStyle(TransparentButtonStyle())
                        .padding(.trailing, 20)
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut)
        
    }

    func CouponBackground() -> some View {
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let waveLength = width / 20
                    let amplitude = height / 20

                    path.move(to: CGPoint(x: 0, y: 0))
                    for x in stride(from: 0, to: width, by: 1) {
                        let relativeX = x / waveLength
                        let y = amplitude * sin(relativeX * .pi * 2) + amplitude
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.closeSubpath()
                }
                .fill(Color.white)
            }
        }
    
    func openSafariView(_ verify: String) {
        print("VERIFY: \(verify)")
        let stringWithoutQuotes = verify.replacingOccurrences(of: "\"", with: "")
        print("stringWithoutQuotes: \(stringWithoutQuotes)")
            guard let url = URL(string: "http://163.17.136.73/web/login.aspx?\(stringWithoutQuotes)") else {
            print("无法构建有效的 URL-http://163.17.136.73/web_login.aspx?\(stringWithoutQuotes)")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let mainWindow = windowScene.windows.first {
                DispatchQueue.main.async {
                    mainWindow.rootViewController?.present(safariViewController, animated: true, completion: nil)
                }
            }else{
                print("無法顯示2")
            }
        }else{
            print("無法顯示")
        }
    }

    private func postTicker(completion: @escaping (String?, Error?) -> Void) {
            UserDefaults.standard.synchronize()
            class URLSessionSingleton {
                static let shared = URLSessionSingleton()
                let session: URLSession
                private init() {
                    let config = URLSessionConfiguration.default
                    config.httpCookieStorage = HTTPCookieStorage.shared
                    config.httpCookieAcceptPolicy = .always
                    session = URLSession(configuration: config)
                }
            }

            let url = URL(string: "http://163.17.136.73/api/values/post")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = PostData(userID: userName, TickerID: ticker.id)
            let jsonData = try! JSONEncoder().encode(body)

            request.httpBody = jsonData
            print("body:\(body)")
            print("jsonData:\(jsonData)")
            URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("StudySpaceList - Connection error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    if let responseData = data {
                                   let errorString = String(data: responseData, encoding: .utf8)
                                   print("Server Error: \(errorString ?? "")")
                               }
                    print("StudySpaceList - HTTP error: \(httpResponse.statusCode)")
                }
                else if let data = data{
                    print(data)
                    let decoder = JSONDecoder()
                    print(String(data: data, encoding: .utf8)!)
                    verify = String(data: data, encoding: .utf8)!
                    DispatchQueue.main.async {
                        completion(verify, nil)
                    }
                }
            }
            .resume()
        }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}


struct TransparentButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Color.clear)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct TickerView_Previews: PreviewProvider {
    static var previews: some View {
        TickerView()
            .environmentObject(TickerStore())
    }
}
