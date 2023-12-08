//
//  SettingsView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/30.
//

import Foundation
import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn
import SafariServices

struct SettingsView: View {
    @State private var selectedLanguage: String = "English"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    SettingsCard(title: "通知設定", iconName: "bell", destination: AnyView(NotificationSettingsView()))

                    SettingsCard(title: "語言設定", iconName: "globe", destination: AnyView(LanguageSettingsView(selectedLanguage: $selectedLanguage)))

                    SettingsCard(title: "隱私權設定", iconName: "hand.raised", destination: AnyView(PrivacySettingsView()))

                    SettingsCard(title: "其他設定", iconName: "ellipsis.circle", destination: AnyView(OtherSettingsView()))

                    SettingsCard(title: "關於應用程式", iconName: "info.circle", destination: AnyView(AboutAppView()))

                    SettingsCard(title: "幫助與支援", iconName: "questionmark.circle", destination: AnyView(HelpSupportView()))

                    HStack {
                        Text("應用程式版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.bottom, 10)

                    Button(action: {
                        UserDefaults.standard.set(false, forKey: "signIn")
                    }, label: {
                        Text("登出")
                    })
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red.opacity(0.6), lineWidth: 1)
                    )
                    .padding(.top, 10)
                }
                .padding()
            }
            .padding(.horizontal)
            .background(Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("設定", displayMode: .inline)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let iconName: String
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 20) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.primary)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.7))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// TODO: Implement these views
struct ProfileSettingsView: View {
    var body: some View {
        Text("Profile Settings")
    }
}

struct NotificationSettingsView: View {
    var body: some View {
        Text("Notification Settings")
    }
}

struct LanguageSettingsView: View {
    @Binding var selectedLanguage: String

    var body: some View {
        Text("Language Settings")
    }
}

struct AboutAppView: View {
    var body: some View {
        Text("About the App")
    }
}

struct HelpSupportView: View {
    var body: some View {
        Text("Help & Support")
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        Text("隱私權設定")
    }
}

struct OtherSettingsView: View {
    var body: some View {
        Text("其他設定")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
