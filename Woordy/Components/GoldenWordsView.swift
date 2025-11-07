import SwiftUI

struct GoldenWordsView: View {
    @EnvironmentObject private var store: WordsStore
    @EnvironmentObject private var golden: GoldenWordsStore

    private let gold = Color(hex: "#FFC107")
    private let darkGold = Color(hex: "#E0A600")
    private let deepTextGold = Color(hex: "#7B4B00")
    private let midTextGold = Color(hex: "#966000")
    private let lightTextGold = Color(hex: "#B97C00")

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Suggestions")
                .font(.custom("Poppins-Bold", size: 22))
                .foregroundColor(Color("MainBlack"))
                .padding(.top, 8)

            if golden.isLoading {
                ProgressView("Thinking...")
                    .tint(.orange)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            else if golden.goldenWords.isEmpty {
                Button {
                    Task { await golden.fetchSuggestions(basedOn: store.words) }
                } label: {
                    Label("Get Golden Words", systemImage: "wand.and.stars")
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(.vertical, 14)
                        .padding(.horizontal, 24)
                        .background(gold)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: gold.opacity(0.4), radius: 8, y: 3)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 4)
            }
            else {
                VStack(spacing: 16) {
                    ForEach(golden.goldenWords) { word in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(word.word.capitalized)
                                .font(.custom("Poppins-Bold", size: 24))
                                .foregroundColor(deepTextGold)

                            Text(word.translation)
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(midTextGold)

                            Text("Este viaje fue una verdadera aventura llena de emociones.")
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(midTextGold.opacity(0.9))

                            HStack {
                                Button {
                                    withAnimation(.spring()) {
                                        golden.accept(word, store: store)
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add (+20 XP)")
                                    }
                                    .font(.custom("Poppins-Medium", size: 13))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(darkGold)
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                                }

                                Spacer()

                                Button {
                                    withAnimation(.easeInOut) {
                                        golden.skip(word)
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark.circle")
                                        Text("Already know")
                                    }
                                    .font(.custom("Poppins-Regular", size: 13))
                                    .foregroundColor(midTextGold)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            // 💫 Теперь со скруглёнными углами, как обычная карточка
                            RoundedRectangle(cornerRadius: 16)
                                .fill(gold)
                        )
                        .shadow(color: darkGold.opacity(0.25), radius: 10, y: 3)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 8)
        .animation(.spring(), value: golden.goldenWords)
    }
}

// MARK: - HEX Helper
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    let mockStore = WordsStore()
    let golden = GoldenWordsStore()
    golden.goldenWords = [
        SuggestedWord(word: "aventura", translation: "adventure"),
        SuggestedWord(word: "descubrir", translation: "to discover")
    ]

    return ScrollView {
        VStack(spacing: 32) {
            Text("Recently added")
                .font(.custom("Poppins-Bold", size: 22))
                .foregroundColor(Color("MainBlack"))
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)

            WordCardView(
                word: "Sabroso",
                translation: "Вкусный",
                type: "adjective",
                example: "Este plato es muy sabroso.",
                comment: nil,
                tag: "Social",
                onDelete: {}
            )

            GoldenWordsView()
                .environmentObject(mockStore)
                .environmentObject(golden)
        }
        .background(Color(.systemGroupedBackground))
    }
}
