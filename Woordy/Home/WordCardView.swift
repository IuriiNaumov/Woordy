import SwiftUI
import AVFoundation

struct WordCardView: View {
    let word: String
    let translation: String?
    let type: String?
    let category: String?
    let categoryColor: Color?
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if let category = category,
               let categoryColor = categoryColor {
                Text(category)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(categoryColor)
                    .clipShape(Capsule())
            }
            
            // MARK: Word Row
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(word)
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(.black)
                        if let type = type {
                            Text(type)
                                .font(.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if let translation = translation {
                        Text(translation)
                            .font(.custom("Poppins-Regular", size: 20))
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                
                // MARK: Speaker Button
                Button(action: speakWord) {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
    
    // MARK: - Voice
    private func speakWord() {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
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
