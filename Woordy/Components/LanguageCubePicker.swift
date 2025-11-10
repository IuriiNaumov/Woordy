import SwiftUI


struct LanguageCubePicker: View {
    @Binding var selectedLanguage: String
    var title: String
    var languages: [LanguageOption]
    var blockedLanguage: String? = nil

    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 16)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(.mainBlack)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(languages) { lang in
                    let isBlocked = lang.name == blockedLanguage

                    LanguageCube(
                        language: lang,
                        isSelected: selectedLanguage == lang.name,
                        isBlocked: isBlocked
                    ) {
                        if !isBlocked {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedLanguage = lang.name
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
}

struct LanguageCube: View {
    let language: LanguageOption
    let isSelected: Bool
    let isBlocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(language.flag)
                    .font(.system(size: 42))
                Text(language.name)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(isBlocked ? .gray : .mainBlack)
            }
            .frame(width: 110, height: 110)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(isSelected ? language.color :
                          isBlocked ? Color.gray.opacity(0.15) :
                          language.color.opacity(0.25))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isBlocked ? Color.gray.opacity(0.4) :
                        language.color.opacity(isSelected ? 0.9 : 0.4),
                        lineWidth: 2
                    )
            )
            .shadow(
                color: isBlocked ? .clear :
                    language.color.opacity(isSelected ? 0.45 : 0.15),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 4 : 2
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .opacity(isBlocked ? 0.5 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
        .disabled(isBlocked)
    }
}
