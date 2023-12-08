//
//  MindfulnessHubView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI
import AVFoundation
import Combine

struct IntroView: View {
    @Binding var isShowing: Bool
    @State private var dontShowAgain: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#A8A39D")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                Text("正念的科學")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
                
                ScrollView {
                    
                    Text("""
                    正念冥想是一種結合專注力和正念的技術，通過練習可以增強我們的專注力並促進心靈的平靜。正念冥想不僅幫助人們減少壓力、控制焦慮和抑鬱，還能提升生活質量。特別是在面對困難和挑戰時，正念冥想可以提供支持，幫助我們保持冷靜和集中。透過定期的正念練習，您不僅可以提高日常生活中的專注力，還能在面對壓力時保持冷靜。研究顯示，正念冥想還可以幫助改善睡眠質量、降低血壓、並有效減少由壓力引起的炎症反應。因此，無論您是想要提升專注力、減輕壓力還是改善睡眠，正念冥想都是一個值得嘗試的選擇。
                    """)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                VStack(alignment: .leading, spacing: 10) {
                    ScrollView {
                        
                        Text("探索功能：")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("• 正念冥想計時器：透過正念冥想，您可以在壓力下更好地掌控自己的情緒和感受，同時提高專注力和改善睡眠質量。")
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Text("• 呼吸練習工具：利用呼吸練習工具，可以學習正確的呼吸技巧，以增加肺活量、穩定核心力量，並改善身體的氧氣供應。此外，呼吸練習還能舒緩緊張的心情、減輕壓力和改善失眠問題。在運動前後，控制呼吸的速度、節奏和深度能夠帶來許多好處，例如減輕壓力和賽前焦慮、提高注意力、改善血液循環和心臟健康。")
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Text("• 正念引言或名言：正念引言或名言能為您的日常生活帶來啟示和智慧，鞏固您的正念練習，並幫助您在面對生活的困境和挑戰時保持積極和平靜的心態。")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                
                HStack {
                    Image(systemName: dontShowAgain ? "checkmark.square.fill" : "square")
                        .foregroundColor(.white)
                        .onTapGesture {
                            dontShowAgain.toggle()
                        }
                    Text("不再顯示")
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: closeIntro) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    func closeIntro() {
        if dontShowAgain {
            UserDefaults.standard.set(true, forKey: "dontShowIntroAgain")
        }
        isShowing = false
    }
}

struct MindfulnessHubView: View {
    @State private var isShowingIntro: Bool = !UserDefaults.standard.bool(forKey: "dontShowIntroAgain")
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                FeatureButton(title: "正念冥想計時器", destination: MeditationTimerView(), icon: "timer")
                FeatureButton(title: "呼吸練習工具", destination: BreathingExerciseView(), icon: "wind")
                FeatureButton(title: "正念引言或名言", destination: MindfulnessQuoteView(), icon: "quote.bubble")
            }
            .padding()
            
            if isShowingIntro {
                IntroView(isShowing: $isShowingIntro)
            }
        }
    }
}

struct FeatureButton<Destination: View>: View {
    var title: String
    var destination: Destination
    var icon: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: "#A8A39D"))
                    Text(title)
                        .font(.title2)
                        .foregroundColor(Color(hex: "#A8A39D"))
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

class AudioPlayer: ObservableObject {
    var player: AVAudioPlayer?
    
    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.play()
        } catch {
            print("播放聲音失敗")
        }
    }
    
    func stopSound() {
        player?.stop()
    }
}

struct MeditationTimerView: View {
    @State private var meditationTime: Double = 10
    @State private var remainingTime: Double = 10 * 60
    @State private var isPlaying: Bool = false
    @State private var selectedSound: Int = 0
    let sounds = ["Rain", "Forest", "Stream", "Guided Meditation"]
    
    @StateObject private var audioPlayer = AudioPlayer()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F5F3F0"), Color(hex: "#A8A39D")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text(timeString(time: remainingTime))
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(Color.white)
                
                Slider(value: $meditationTime, in: 1...60, step: 1)
                    .padding(.horizontal, 40)
                    .accentColor(Color.white)
                
                Button(action: togglePlayPause) {
                    Text(isPlaying ? "暫停" : "開始")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(40)
                }
                .shadow(radius: 10)
                
                Picker("Meditation Sound", selection: $selectedSound) {
                    ForEach(0..<sounds.count) {
                        Text(sounds[$0]).font(.title2)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(Color.white)
                .onChange(of: selectedSound) { newValue in
                    if isPlaying {
                        audioPlayer.stopSound()
                        audioPlayer.playSound(soundName: sounds[newValue])
                    }
                }
            }
            .padding()
            .onReceive(timer) { _ in
                if isPlaying {
                    if remainingTime > 0 {
                        remainingTime -= 1
                    } else {
                        isPlaying = false
                        audioPlayer.stopSound()
                    }
                }
            }
        }
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            remainingTime = meditationTime * 60
            audioPlayer.playSound(soundName: sounds[selectedSound])
        } else {
            audioPlayer.stopSound()
        }
    }
    
    func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct BreathingExerciseView: View {
    @State private var isBreathing: Bool = false
    @State private var scale: CGFloat = 1
    @State private var phase: BreathingPhase = .inhale
    @StateObject private var audioPlayer = AudioPlayer()
    
    enum BreathingPhase {
        case inhale, exhale
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F5F3F0"), Color(hex: "#A8A39D")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text(phaseDescription)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Circle()
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 4))
                    .foregroundColor(Color(hex: "#A8A39D").opacity(0.2))
                
                Button(action: toggleBreathing) {
                    Text(isBreathing ? "停止" : "開始呼吸練習")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(40)
                }
                .shadow(radius: 10)
            }
            .padding()
        }
    }
    
    var phaseDescription: String {
        switch phase {
        case .inhale:
            return "吸氣"
        case .exhale:
            return "呼氣"
        }
    }
    
    func toggleBreathing() {
        isBreathing.toggle()
        if isBreathing {
            startBreathingCycle()
        }
    }
    
    func startBreathingCycle() {
        let duration = 4.0
        
        switch phase {
        case .inhale:
            withAnimation {
                scale = 1.5
            }
            audioPlayer.playSound(soundName: "InhaleSound")
        case .exhale:
            withAnimation {
                scale = 1.0
            }
            audioPlayer.playSound(soundName: "ExhaleSound")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if isBreathing {
                switch phase {
                case .inhale:
                    phase = .exhale
                case .exhale:
                    phase = .inhale
                }
                startBreathingCycle()
            }
        }
    }
}

struct MindfulnessQuoteView: View {
    @State private var currentQuote: Int = 0
    let quotes = [
        ("保持當下。", "學會專注於當前的事物，將注意力集中在眼前的瞬間。", "waveform.path.ecg"),
        ("擁抱平靜。", "在日常生活中尋找內心的平靜，學會冷靜對待周遭的環境。", "leaf"),
        ("專注於現在。", "把精力集中在當下，避免過多擔憂過去或未來。", "hourglass.bottomhalf.fill"),
        ("活在當下。", "享受每一個當下，不要讓生活中的美好時刻溜走。", "sun.max.fill")
    ]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F5F3F0"), Color(hex: "#A8A39D")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            TabView(selection: $currentQuote) {
                ForEach(0..<quotes.count, id: \.self) { index in
                    MindfulnessQuoteDetailView(quote: quotes[index].0, description: quotes[index].1, symbol: quotes[index].2)
                        .tag(index)
                }
            }
            .frame(maxHeight: 300) // 限制 TabView 的高度
            .clipped()
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct MindfulnessQuoteDetailView: View {
    var quote: String
    var description: String
    var symbol: String

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundColor(Color(hex: "#A8A39D"))
            Text(quote)
                .font(.title)
                .foregroundColor(Color(hex: "#A8A39D"))
            Text(description)
                .font(.body)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}


struct MindfulnessHubView_Previews: PreviewProvider {
    static var previews: some View {
        MindfulnessHubView()
    }
}
