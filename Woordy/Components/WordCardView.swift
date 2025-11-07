import SwiftUI
import AVFoundation

struct WordCardView: View, Equatable {
    let word: String
    let translation: String?
    let type: String?
    let example: String?
    let comment: String?
    let tag: String?
    let onDelete: () -> Void

    static func == (lhs: WordCardView, rhs: WordCardView) -> Bool {
        lhs.word == rhs.word &&
        lhs.translation == rhs.translation &&
        lhs.type == rhs.type &&
        lhs.example == rhs.example &&
        lhs.comment == rhs.comment &&
        lhs.tag == rhs.tag
    }

    @State private var isExpanded = true
    @State private var isPlaying = false
    @State private var highlightedExample: AttributedString = ""

    private let duolingoGold = Color(hexRGB: 0xFFC107)
    private let duolingoDarkGold = Color(hexRGB: 0xE59E00)

    private var isGolden: Bool { tag == "Golden" }

    private var backgroundColor: Color {
        switch tag {
        case "Social": return Color(hexRGB: 0xFFDFA4)
        case "Chat":   return Color(hexRGB: 0xB9E3FF)
        case "Apps":   return Color(hexRGB: 0xC6F6D5)
        case "Street": return Color(hexRGB: 0xFFC6C9)
        case "Movies": return Color(hexRGB: 0xE4D2FF)
        case "Travel": return Color(hexRGB: 0xFFF1B2)
        case "Work":   return Color(hexRGB: 0xBDF4F2)
        case "Golden": return duolingoGold
        default:       return Color(hexRGB: 0xF6F6F6)
        }
    }

    private var textColor: Color {
        isGolden ? .white : Color("MainBlack")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isExpanded {
                if let tag = tag {
                    Text(tag)
                        .font(.custom("Poppins-Medium", size: 14))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 4)
                        .background(isGolden ? Color.white.opacity(0.25) : Color("MainGrey").opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundColor(isGolden ? .white : Color("MainBlack"))
                }

                HStack(alignment: .center, spacing: 8) {
                    Text(word)
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(textColor)
                    Spacer()
                    Button(action: playAudio) {
                        SoundWavesView(isPlaying: isPlaying)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }

                if let type = type {
                    Text(type)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(isGolden ? .white.opacity(0.9) : Color("MainGrey"))
                }

                if let translation = translation {
                    Text(translation)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(textColor)
                }

                if let _ = example {
                    Text(highlightedExample)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(textColor)
                }

                if let comment = comment, !comment.isEmpty {
                    Text(comment)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(isGolden ? .white.opacity(0.85) : Color("MainGrey"))
                        .padding(.top, 4)
                }

                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(isGolden ? .white.opacity(0.9) : .red)
                            .padding(.trailing, 2)
                            .padding(.top, 8)
                    }
                    .buttonStyle(.plain)
                }

            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 8) {
                        Text(word)
                            .font(.custom("Poppins-Bold", size: 22))
                            .foregroundColor(textColor)
                        Spacer()
                        Button(action: playAudio) {
                            SoundWavesView(isPlaying: isPlaying)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 8)
                    }

                    if let translation = translation {
                        Text(translation)
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(textColor)
                            .multilineTextAlignment(.leading)
                    }

                    HStack {
                        Spacer()
                        Button(action: onDelete) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(isGolden ? .white.opacity(0.9) : .red)
                                .padding(.trailing, 2)
                                .padding(.top, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(16)
        .scaleEffect(isExpanded ? 1.02 : 0.98)
        .shadow(
            color: isGolden ? duolingoDarkGold.opacity(0.5) : Color("MainBlack").opacity(isExpanded ? 0.15 : 0.05),
            radius: isGolden ? 14 : (isExpanded ? 12 : 4),
            x: 0, y: isGolden ? 6 : (isExpanded ? 6 : 2)
        )
        .animation(.interpolatingSpring(stiffness: 100, damping: 12), value: isExpanded)
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 12)) {
                isExpanded.toggle()
            }
        }
        .padding(.top, 12)
        .onAppear {
            if let example = example {
                highlightedExample = Self.makeHighlightedExample(comment: example, word: word, isGolden: isGolden)
            } else {
                highlightedExample = ""
            }
        }
        .onChange(of: example) { newValue in
            if let example = newValue {
                highlightedExample = Self.makeHighlightedExample(comment: example, word: word, isGolden: isGolden)
            } else {
                highlightedExample = ""
            }
        }
    }

    private func playAudio() {
        Task {
            isPlaying = true
            await AudioManager.shared.play(word: word)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation { isPlaying = false }
        }
    }

    private static func makeHighlightedExample(comment: String, word: String, isGolden: Bool) -> AttributedString {
        var attributedString = AttributedString(comment)
        if let range = attributedString.range(of: word, options: .caseInsensitive) {
            attributedString[range].foregroundColor = isGolden ? .white : .orange
            attributedString[range].font = .custom("Poppins-Bold", size: 16)
        }
        return attributedString
    }
}
#Preview {
    VStack(spacing: 20) {
        WordCardView(
            word: "Sabroso",
            translation: "Вкусный",
            type: "adjective",
            example: "Este plato es muy sabroso y delicioso.",
            comment: "Мое любимое слово!",
            tag: "Golden",
            onDelete: {}
        )
        WordCardView(
            word: "Chido",
            translation: "Круто",
            type: "adjective",
            example: "La fiesta estuvo chido y divertida.",
            comment: nil,
            tag: "Slang",
            onDelete: {}
        )
    }
    .padding()
}
