import SwiftUI

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

    private var backgroundColor: Color {
        switch tag {
        case "Social": return Color(hexRGB: 0xFFDFA4)
        case "Chat":   return Color(hexRGB: 0xB9E3FF)
        case "Apps":   return Color(hexRGB: 0xC6F6D5)
        case "Street": return Color(hexRGB: 0xFFC6C9)
        case "Movies": return Color(hexRGB: 0xE4D2FF)
        case "Travel": return Color(hexRGB: 0xFFF1B2)
        case "Work":   return Color(hexRGB: 0xBDF4F2)
        default:       return Color(hexRGB: 0xFFF8E7)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isExpanded {
                if let tag = tag {
                    Text(tag)
                        .font(.custom("Poppins-Medium", size: 14))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 4)
                        .background(Color("MainGrey").opacity(0.2))
                        .clipShape(Capsule())
                }

                HStack(alignment: .center, spacing: 8) {
                    Text(word)
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(Color("MainBlack"))
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
                        .foregroundColor(Color("MainGrey"))
                }

                if let translation = translation {
                    Text(translation)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color("MainBlack"))
                }

                if let _ = example {
                    Text(highlightedExample)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color("MainBlack"))
                }

                if let comment = comment, !comment.isEmpty {
                    Text(comment)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color("MainGrey"))
                        .padding(.top, 4)
                }

                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
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
                            .foregroundColor(Color("MainBlack"))
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
                            .foregroundColor(Color("MainBlack"))
                            .multilineTextAlignment(.leading)
                    }

                    HStack {
                        Spacer()
                        Button(action: onDelete) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
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
        .shadow(color: Color("MainBlack").opacity(isExpanded ? 0.15 : 0.05),
                radius: isExpanded ? 12 : 4,
                x: 0, y: isExpanded ? 6 : 2)
        .animation(.interpolatingSpring(stiffness: 100, damping: 12), value: isExpanded)
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 12)) {
                isExpanded.toggle()
            }
        }
        .padding(.top, 12)
        .onAppear {
            if let example = example {
                highlightedExample = Self.makeHighlightedExample(comment: example, word: word)
            } else {
                highlightedExample = ""
            }
        }
        .onChange(of: example) { newValue in
            if let example = newValue {
                highlightedExample = Self.makeHighlightedExample(comment: example, word: word)
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

    private static func makeHighlightedExample(comment: String, word: String) -> AttributedString {
        var attributedString = AttributedString(comment)
        if let range = attributedString.range(of: word, options: .caseInsensitive) {
            attributedString[range].foregroundColor = .orange
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
            tag: "Social",
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
