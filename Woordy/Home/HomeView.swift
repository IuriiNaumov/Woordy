import SwiftUI
import AVFoundation

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var hSize
    @Environment(\.colorScheme) private var colorScheme

    @State private var selectedTag: String? = nil
    @State private var selectedTab: Tab = .home
    @State private var activeTabPulse: Tab? = nil
    @State private var showAddWordView = false

    enum Tab: String, CaseIterable, Identifiable {
        case home, trophy, search
        var id: String { rawValue }

        var systemImage: String {
            switch self {
            case .home: return "house"
            case .trophy: return "trophy"
            case .search: return "magnifyingglass"
            }
        }
    }

    let words: [WordCard] = [
        WordCard(category: "Social", title: "Sabroso", type: "noun", translation: "Вкусный", color: Color(hexRGB: 0xE6D3F1)),
        WordCard(category: "Chat", title: "Chido", type: "noun", translation: "Круто", color: Color(hexRGB: 0xCDE4F3)),
        WordCard(category: "Movies", title: "Bonito", type: "adjective", translation: "Красивый", color: Color(hexRGB: 0xD9E764))
    ]

    private var filteredWords: [WordCard] {
        guard let tag = selectedTag else { return words }
        return words.filter { $0.category == tag }
    }

    private var isCompact: Bool { hSize == .compact }
    private var headerTopPadding: CGFloat { isCompact ? 8 : 12 }
    private var sectionSpacing: CGFloat { isCompact ? 18 : 24 }
    private var horizontalPadding: CGFloat { isCompact ? 16 : 20 }

    var body: some View {
        VStack(alignment: .leading, spacing: sectionSpacing) {

            HStack {
                Text("Hi, Yura")
                    .font(.custom("Poppins-Bold", size: 34))
                Spacer()
                Button(action: {}) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 22))
                        .foregroundColor(.primary)
                        .contentShape(Rectangle())
                        .padding(8)
                }
                .buttonStyle(.plain)
                .padding(.trailing, horizontalPadding)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, headerTopPadding)
            .padding(.bottom, 10)

            TagsView(selectedTag: $selectedTag)
                .padding(.horizontal, horizontalPadding)

            Text(selectedTag == nil
                 ? "You have \(filteredWords.count) words"
                 : "You have \(filteredWords.count) words in \(selectedTag!)")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 4)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(filteredWords) { word in
                        WordCardView(
                            word: word.title,
                            translation: word.translation,
                            type: word.type,
                            category: word.category,
                            categoryColor: word.color
                        )
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }


        }
        .safeAreaInset(edge: .bottom) {
            tabBar
        }
        .fullScreenCover(isPresented: $showAddWordView) {
            AddWordView()
        }
    }

    private var tabBar: some View {
        ZStack {
            HStack {
                Spacer(minLength: 0)
                HStack(spacing: isCompact ? 12 : 16) {
                    ForEach(Tab.allCases) { tab in
                        Button {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                activeTabPulse = tab
                                selectedTab = tab
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                activeTabPulse = nil
                            }
                        } label: {
                            let systemName = iconName(for: tab)
                            Image(systemName: systemName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(selectedTab == tab ? .primary : .secondary)
                                .frame(width: 48, height: 48)
                                .background(
                                    Circle()
                                        .fill(selectedTab == tab ? Color.primary.opacity(0.08) : .clear)
                                )
                                .scaleEffect(activeTabPulse == tab ? 1.15 : 1.0)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color(.systemGray6))
                )
                Spacer(minLength: 100)
            }

            HStack {
                Spacer()
                Button(action: {
                    showAddWordView = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 62, height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 54)
                                .fill(Color("MainBlack"))
                        )
                }
            }
            .padding(.trailing, 18)
        }
        .padding(.vertical, 10)
    }

    // MARK: - Helper
    private func iconName(for tab: Tab) -> String {
        switch tab {
        case .search:
            return tab.systemImage // всегда без fill
        default:
            return selectedTab == tab ? tab.systemImage + ".fill" : tab.systemImage
        }
    }
}

// MARK: - WordCard Struct
struct WordCard: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let type: String?
    let translation: String?
    let color: Color
}

#Preview {
    HomeView()
}
