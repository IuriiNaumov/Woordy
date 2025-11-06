import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject private var store: WordsStore

    private let maxLevel = 50
    private let xpPerWord = 10

    private var totalWords: Int { store.totalWordsAdded }
    private var totalXP: Int { totalWords * xpPerWord }

    private var level: Int {
        var currentLevel = 1
        var requiredWords = 0
        while currentLevel < maxLevel {
            let wordsForNext = 3 + (currentLevel - 1) * 2
            requiredWords += wordsForNext
            if totalWords < requiredWords { break }
            currentLevel += 1
        }
        return min(currentLevel, maxLevel)
    }

    private var wordsForNextLevel: Int { 3 + (level - 1) * 2 }

    private var totalWordsForNextLevel: Int {
        var total = 0
        for i in 1..<level { total += 3 + (i - 1) * 2 }
        total += wordsForNextLevel
        return total
    }

    private var wordsToNextLevel: Int {
        max(0, totalWordsForNextLevel - totalWords)
    }

    @State private var displayProgress: Double = 0.0
    private var realProgress: Double {
        let previousTotal = (1..<level).reduce(0) { $0 + (3 + ($1 - 1) * 2) }
        let currentProgress = totalWords - previousTotal
        return min(1.0, Double(currentProgress) / Double(wordsForNextLevel))
    }

    private var levelColor: Color {
        switch level {
        case 1...5:  return Color(hexRGB: 0xFFDFA4)
        case 6...10: return Color(hexRGB: 0xC6F6D5)
        case 11...20: return Color(hexRGB: 0xB9E3FF)
        case 21...30: return Color(hexRGB: 0xE4D2FF)
        case 31...40: return Color(hexRGB: 0xFFC6C9)
        case 41...50: return Color(hexRGB: 0xFFF1B2)
        default:      return Color(hexRGB: 0xBDF4F2)
        }
    }

    private var darkerLevelText: Color {
        darkerShade(of: levelColor, by: 0.35)
    }

    private let progressColor = Color(hexRGB: 0xA8E6CF)
    private let goldText = Color(hexRGB: 0xB88A00)
    private let goldBackground = Color(hexRGB: 0xFFF1B2)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(levelColor.opacity(0.25))
                        .frame(width: 72, height: 72)
                        .shadow(color: Color("MainBlack").opacity(0.05), radius: 3, x: 0, y: 2)

                    Image(systemName: "person.fill")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color("MainBlack"))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Yura")
                        .font(.custom("Poppins-Bold", size: 22))
                        .foregroundColor(Color("MainBlack"))

                    HStack(spacing: 10) {
                        Label("Lv \(level)", systemImage: "star.fill")
                            .font(.custom("Poppins-Bold", size: 13))
                            .foregroundColor(darkerLevelText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(levelColor))

                        Label("\(totalXP) XP", systemImage: "bolt.fill")
                            .font(.custom("Poppins-Bold", size: 13))
                            .foregroundColor(goldText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(goldBackground))
                    }
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color("MainGrey").opacity(0.15))
                        .frame(width: 248, height: 16)

                    Capsule()
                        .fill(progressColor)
                        .frame(width: CGFloat(displayProgress) * 240, height: 16)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: displayProgress)
                }

                Text("\(totalXP) XP – \(wordsToNextLevel * xpPerWord) XP to level up")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(Color("MainGrey"))
            }
            .padding(.trailing, 20)
            .onAppear {
                displayProgress = realProgress
            }
            .onChange(of: realProgress) { _, newValue in
                if newValue < displayProgress {
                    withAnimation(.easeOut(duration: 0.3)) {
                        displayProgress = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            displayProgress = newValue
                        }
                    }
                } else {
                    withAnimation(.easeOut(duration: 0.6)) {
                        displayProgress = newValue
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color("MainBlack").opacity(0.05), radius: 6, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

#Preview {
    ProfileHeaderView().environmentObject(WordsStore())
}

extension Color {
    init(hexRGB: UInt) {
        let r = Double((hexRGB >> 16) & 0xFF) / 255
        let g = Double((hexRGB >> 8) & 0xFF) / 255
        let b = Double(hexRGB & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
