import SwiftUI
import AVFoundation

struct WordCardView: View {
    let word: String
    let translation: String?
    let type: String?
    let category: String?
    let categoryColor: Color?
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var pulse = false
    
    private let elevenLabsURL = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/MDLAMJ0jxkpYkjXbmG4t")!
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if let category = category,
               let categoryColor = categoryColor {
                Text(category)
                    .font(.custom("Poppins-Medium", size: 14))
                    .padding(.horizontal, 28)
                    .padding(.vertical, 4)
                    .background(categoryColor)
                    .clipShape(Capsule())
            }
            
            HStack(alignment: .center) {
                Text(word)
                    .font(.custom("Poppins-Bold", size: 22)).padding([.top, .bottom], 4)
                    .foregroundColor(.black)

                
                if let type = type {
                    Text(type)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPlaying = true
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        playElevenLabsVoice()
                    }
                }) {
                    SoundWavesView(isAnimating: isPlaying)
                        .frame(width: 32, height: 26)
                        .contentShape(Rectangle())
                        .scaleEffect(isPlaying ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.15), value: isPlaying)
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                if let translation = translation {
                    Text(translation)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.black.opacity(0.9))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func playElevenLabsVoice() {
        var request = URLRequest(url: elevenLabsURL)
        request.httpMethod = "POST"
        request.addValue("sk_74ad1c950a9558250e576c5051863efb40250ec61111ae65", forHTTPHeaderField: "xi-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("audio/mpeg", forHTTPHeaderField: "Accept")

        let body: [String: Any] = [
            "text": word,
            "voice_settings": [
                "stability": 0.4,
                "similarity_boost": 0.9
            ],
            "model_id": "eleven_multilingual_v2",
            "output_format": "mp3_44100_128"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса:", error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Нет ответа от сервера")
                return
            }

            print("HTTP статус:", httpResponse.statusCode)
            guard httpResponse.statusCode == 200 else {
                if let data = data, let text = String(data: data, encoding: .utf8) {
                    print("Ответ:", text)
                }
                return
            }

            guard let data = data else {
                print("Нет данных от ElevenLabs")
                return
            }

            DispatchQueue.main.async {
                do {
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.play()
                    self.isPlaying = true
                    self.pulse = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + (self.audioPlayer?.duration ?? 1)) {
                        self.isPlaying = false
                        self.pulse = false
                    }
                } catch {
                    print("Ошибка воспроизведения аудио:", error)
                }
            }
        }.resume()
    }
    
    struct SoundWavesView: View {
        @State private var barHeights: [CGFloat] = [8, 12, 8]
        let isAnimating: Bool
        
        let barWidth: CGFloat = 4
        let maxHeight: CGFloat = 20
        let minHeight: CGFloat = 6
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: barWidth, height: barHeights[index])
                        .cornerRadius(2)
                }
            }
            .onAppear {
                if isAnimating {
                    startAnimation()
                }
            }
            .onChange(of: isAnimating) { animating in
                if animating {
                    startAnimation()
                } else {
                    resetBars()
                }
            }
        }
        
        private func startAnimation() {
            withAnimation(Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                barHeights = barHeights.map { _ in CGFloat.random(in: minHeight...maxHeight) }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if isAnimating {
                    startAnimation()
                }
            }
        }
        
        private func resetBars() {
            withAnimation {
                barHeights = [8, 12, 8]
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WordCardView(
            word: "Sabroso",
            translation: "Вкусный",
            type: "noun",
            category: "Slang",
            categoryColor: Color(hex: 0xE6D3F1)
        )
        WordCardView(
            word: "Chido",
            translation: "Круто",
            type: nil,
            category: nil,
            categoryColor: nil
        )
    }
    .padding()
}
