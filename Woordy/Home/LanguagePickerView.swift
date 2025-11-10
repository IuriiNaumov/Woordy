import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var languageStore: LanguageStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                Text("Language Preferences")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(.mainBlack)
                    .padding(.top, 20)

                LanguageCubePicker(
                    selectedLanguage: $languageStore.nativeLanguage,
                    title: "I speak",
                    languages: LanguageSelectionView.availableLanguages
                )

                LanguageCubePicker(
                    selectedLanguage: $languageStore.learningLanguage,
                    title: "I’m learning",
                    languages: LanguageSelectionView.availableLanguages,
                    blockedLanguage: languageStore.nativeLanguage
                )

                Button {
                    dismiss()
                } label: {
                    Text("Save and go back")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 60)
                        .background(Color(hex: "#6F68A8"))
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: "#6F68A8").opacity(0.3), radius: 6, y: 3)
                }
                .padding(.top, 30)
            }
            .padding(.bottom, 50)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    static let availableLanguages = [
        LanguageOption(name: "English", flag: "🇬🇧", color: Color(hex: "#CDEBF1")),
        LanguageOption(name: "Español", flag: "🇲🇽", color: Color(hex: "#DEF1D0")),
        LanguageOption(name: "Русский", flag: "🇷🇺", color: Color(hex: "#FFE6A7")),
        LanguageOption(name: "Français", flag: "🇫🇷", color: Color(hex: "#E4D2FF")),
        LanguageOption(name: "Deutsch", flag: "🇩🇪", color: Color(hex: "#FFD1A9")),
        LanguageOption(name: "Italiano", flag: "🇮🇹", color: Color(hex: "#D2FFD5")),
        LanguageOption(name: "Português", flag: "🇧🇷", color: Color(hex: "#FFF4B0")),
        LanguageOption(name: "한국어", flag: "🇰🇷", color: Color(hex: "#D2E0FF")),
        LanguageOption(name: "中文", flag: "🇨🇳", color: Color(hex: "#FFD5D2"))
    ]
}
