//
//  QuoteView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

struct QuoteView: View {
    var quote: String = "讓小改變變得簡單，並持之以恆。"
    var source: String = "James Clear（詹姆斯·克利爾）"
      
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?
    @EnvironmentObject var tabBarSettings: TabBarSettings
    
    var body: some View {
        ZStack {
            Image("quoteback")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text(quote)
                    .font(.custom("Georgia-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .foregroundColor(Color(hex: "#463C29"))
                    .padding(.horizontal, 30)
                    
                Text("— \(source)")
                    .italic()
                    .foregroundColor(Color(hex: "#434235"))
                    .padding(10)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.45))
            )
            .padding(10)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.imageToShare = self.captureView()
                        self.showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5)
                    }
                    .padding(.leading, 20)
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let imageToShare = self.imageToShare {
                ShareSheet(activityItems: [imageToShare])
            }
        }
        .onAppear {
                    tabBarSettings.isHidden = true
                }
                .onDisappear {
                    tabBarSettings.isHidden = false
                }
    }
    
    func captureView() -> UIImage? {
        let controller = UIHostingController(rootView: self.body)
        let view = controller.view
        
        let targetSize = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        view?.frame = CGRect(origin: .zero, size: targetSize)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { ctx in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
