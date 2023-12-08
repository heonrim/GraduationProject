//
//  CommunityListView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/27.
//

import SwiftUI
import SafariServices

struct communityPostData: Encodable {
    var userID: String
    var Community: String
}

extension Color {
    static let color = Color("Color")
    static let color1 = Color("Color1")
    static let color2 = Color("Color2")
}

extension Color {
    static let morandiPink = Color(red: 180/255, green: 120/255, blue: 140/255)
    static let morandiBlue = Color(red: 100/255, green: 120/255, blue: 140/255)
    static let morandiGreen = Color(red: 172/255, green: 210/255, blue: 194/255)
    static let morandiBackground = Color(hex: "#F5F3F0")
}

struct CommunityListView: View {
    @AppStorage("uid") private var uid:String = ""
    @State private var selectedSegment = 0
    @State private var selectedCategory = 0
    @State private var searchText: String = ""
    @State private var showingNotifications = false
    @State private var isCommunityIntroShowing = true
    @AppStorage("userName") private var userName:String = ""
    @State var verify: String = ""
    @State private var showingSheet = false
    @EnvironmentObject var communityStore: CommunityStore

    var body: some View {
        
        NavigationView {
            VStack {
                Picker("", selection: $selectedSegment) {
                    Text("已加入").tag(0)
                    Text("探索").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedSegment == 0 {
                    ScrollView {
                        SearchBar(text: $searchText, placeholder: "搜索社群")
                            .padding(.vertical, 5)
                        ForEach(communityStore.communitysIsMember(), id: \.id) { community in
                            Button(action: {
                                print("我是社群")
                                postCommunity(community:community) { verify, error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                    } else if let verify = verify {
                                        openSafariView(verify)
                                    }
                                }
                                
                            }){
                                CommunityCard(community: community)
                            }
                        }
                    }
                } else {
                    ScrollView {
                        SearchBar(text: $searchText, placeholder: "搜索社群")
                            .padding(.vertical, 5)
                        ForEach(communityStore.communitysNotJoined(), id: \.id) { community in
                            Button(action: {
                                print("我是社群")
                                postCommunity(community:community) { verify, error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                    } else if let verify = verify {
                                        openSafariView(verify)
                                    }
                                }
                                
                            }){
                                CommunityCard(community: community)
                            }
                        }
                    }
                }
            }
            .navigationBarItems(
                leading: NotificationButtonView(showingNotifications: $showingNotifications),
                trailing:  Button("創建") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    AddCommunityView()
                        .presentationDetents([ .large, .large])
                }
            )
        }
        .background(
            ZStack {
                LinearGradient(gradient: .init(colors: [Color.color, Color.color1, Color.color2]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                }
            }
        )
        .onAppear() {
            List()
        }
    }
    
    private func List() {
        CommunityList { spaceListMessage in
            printResultMessage(for: spaceListMessage, withOperationName: "CommunityList")
        }
    }
    private func printResultMessage(for message: String, withOperationName operationName: String) {
        if message == "Success" {
            print("\(operationName) Success")
        } else {
            print("\(operationName) failed with message: \(message)")
        }
    }
    func CommunityList(completion: @escaping (String) -> Void) {
        let body: [String: Any] = ["uid": uid]
         phpUrl(php: "CommunityList",type: "list",body:body,store: communityStore){ message in
             //// completion(message[0])
             completion(message["message"]!)
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
    
    private func postCommunity(community: Community,completion: @escaping (String?, Error?) -> Void) {
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

            let url = URL(string: "http://163.17.136.73/api/values/community")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = communityPostData(userID: userName, Community: String(community.id))
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

struct NotificationButtonView: View {
    @Binding var showingNotifications: Bool
    
    var body: some View {
        Button(action: {
            showingNotifications.toggle()
        }) {
            Image(systemName: "bell")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.morandiBlue)
        }
    }
}





struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
                .padding(10)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.2)))
        .padding(.horizontal)
    }
}

struct CommunityCard: View {
    let community: Community
    
    var body: some View {
            HStack(spacing: 15) {
                Image(community.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.morandiPink, lineWidth: 2))
                    .shadow(radius: 5)
                
                VStack(alignment: .leading) {
                    Text(community.communityName)
                        .font(.headline)
                        .foregroundColor(Color.morandiBlue)
                    
                    Text(community.communityDescription)
                        .font(.subheadline)
                        .foregroundColor(Color.morandiGreen)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                .fill(Color.morandiBackground)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5))
    }
}
struct CoverPhotoPicker: View {
    let coverPhotos: [String]
    @Binding var selectedPhotoName: String

    internal var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 3)


    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 20) {
                    ForEach(coverPhotos, id: \.self) { photoName in
                        VStack {
                            Image(photoName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(10)
                                .overlay(
                                    selectedPhotoName == photoName ?
                                        Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .padding(5) : nil
                                )
                        }
                        .onTapGesture {
                            selectedPhotoName = photoName
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("選擇封面照片", displayMode: .inline)
        }
    }
}


struct AddCommunityView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: Int = 0
    @EnvironmentObject var communityStore: CommunityStore
    @State private var coverPhoto: Image? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoverPhotoName: String = ""
    @State private var showingCoverPhotoPicker = false
    @State var messenge = ""
    @State var isError = false
    @State private var showingNameError: Bool = false
    @State private var showingDescriptionError: Bool = false
    @State private var showingComAlert = false
    @State private var alertComMessage = ""
    let coverPhotoNames = (1...29).map { "GP\($0)" }
    let Category = ["學習", "運動", "作息", "飲食"]
    var body: some View {
        Form {
            Section(header: Text("基本資訊").foregroundColor(Color.morandiBlue)) {
                            TextField("社群名稱", text: $name)
                            TextField("描述", text: $description)
                        }

            Section(header: Text("分類").foregroundColor(Color.morandiBlue)) {
                Picker("選擇分類", selection: $selectedCategory) {
                    ForEach(Category.indices) { index in
                        Text(Category[index])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Section(header: Text("封面照片").foregroundColor(Color.morandiBlue)) {
                         Button("選擇封面照片") {
                             showingCoverPhotoPicker = true
                         }
                         if !selectedCoverPhotoName.isEmpty {
                             Image(selectedCoverPhotoName)
                                 .resizable()
                                 .scaledToFit()
                         }
                     }

            if(isError) {
                Text(messenge)
                    .foregroundColor(.red)
            }
            Button(action: {
                if validateInputs() {
                    addCommunity { _ in }
                } else {
                    alertComMessage = generateAlertMessage()
                    showingComAlert = true
                }
            }) {
                            Text("新增社群")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.morandiPink, Color.morandiBlue]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
            .alert(isPresented: $showingComAlert) {
                Alert(title: Text("重要提醒"), message: Text(alertComMessage), dismissButton: .default(Text("好")))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .sheet(isPresented: $showingCoverPhotoPicker) {
                    CoverPhotoPicker(coverPhotos: coverPhotoNames, selectedPhotoName: $selectedCoverPhotoName)
                }
    }
    
    func generateAlertMessage() -> String {
        var message = ""
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            message += "社群名稱不能為空。"
        }
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            message += message.isEmpty ? "描述不能為空。" : "\n描述不能為空。"
        }
        return message
    }

    func validateInputs() -> Bool {
        let isNameValid = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isDescriptionValid = !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        showingNameError = !isNameValid
        showingDescriptionError = !isDescriptionValid

        return isNameValid && isDescriptionValid
    }
    
    func addCommunity(completion: @escaping (String) -> Void) {
        let body: [String: Any] = [
            "communityName": name,
            "communityDescription": description,
            "communityCategory": selectedCategory + 1,
            "image": selectedCoverPhotoName,
        ]

        print("body:\(body)")

        phpUrl(php: "addCommunity" ,type: "addTask",body:body,store: communityStore) { message in
            print("修改飲食回傳：\(String(describing: message["message"]))")
            if message["message"] == "The Community is repeated" {
                isError = true
                messenge = "請勿重複建立社群"
            } else if message["message"] == "User New Community successfully" {
                isError = false
                messenge = ""
                presentationMode.wrappedValue.dismiss()
            } else {
                isError = true
                messenge = "社群建立失敗 請聯繫管理員"
            }
            completion(message["message"]!)
        }
    }
}

struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityListView()
    }
}
