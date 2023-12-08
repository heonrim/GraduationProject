//
//  PsychologyTestView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/24.
//

import SwiftUI
import SafariServices

class SafariViewModel: ObservableObject {
    @Published var showSafariView: Bool = false
    @Published var selectedURL: URL?
}


struct PsychologyTestView: View {
    @StateObject private var viewModel = SafariViewModel()
    
    let testLinks: [TestLink] = [
        TestLink(name: "執行功能測試", url: "https://mind.help/assessments/executive-function-test/", color: Color(hex: "#A8A39D"), icon: "brain", description: "這個測試可以幫助你了解你的執行功能，包括注意力、記憶和決策能力。", provider: "Mind Help"),
        TestLink(name: "意志力測試", url: "https://psycho-tests.com/test/willpower-test/", color: Color(hex: "#92908D"), icon: "bolt.heart", description: "這個測試旨在評估你的意志力，幫助你了解如何在面對誘惑和困難時保持堅定。", provider: "Psycho-Tests")
    ]

    var body: some View {
            ZStack {
                Color(hex: "#EDEDED").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(testLinks, id: \.name) { link in
                            createCard(for: link)
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $viewModel.showSafariView) {
                    if let url = viewModel.selectedURL {
                        SafariView(url: url)
                    }
                }
            }
            .navigationBarTitle("心理學測試", displayMode: .inline)
        }

    func createCard(for link: TestLink) -> some View {
            VStack {
                VStack {
                    Image(systemName: link.icon)
                        .font(.largeTitle)
                        .foregroundColor(link.color)
                        .padding(.bottom, 5)
                    Text(link.name)
                        .font(.headline)
                        .foregroundColor(link.color)
                }
                .padding(.bottom, 10)
                
                Text(link.description)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 5)
                
                VStack {
                    Text("提供者: \(link.provider)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("所有測試內容和結果均來源於第三方網站，不屬於「我習慣了」的內容。")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 5)
                .padding(.vertical, 10)
                
                Button(action: {
                            if let url = URL(string: link.url) {
                                viewModel.selectedURL = url
                                viewModel.showSafariView = true
                            }
                        }) {
                    Text("開始測試")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [link.color, link.color.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(20)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.gray.opacity(0.3), radius: 15, x: 0, y: 10)
            .padding(.horizontal)
        }
}

struct TestLink {
    let name: String
    let url: String
    let color: Color
    let icon: String
    let description: String
    let provider: String
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}

}

struct PsychologyTestView_Previews: PreviewProvider {
    static var previews: some View {
        PsychologyTestView()
    }
}
