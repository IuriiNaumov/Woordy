import SwiftUI
import AVFoundation

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var hSize
    @EnvironmentObject private var store: WordsStore

    @State private var showAddWordView = false
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable, Identifiable {
        case home, add, list
        var id: String { rawValue }
    }

    private var isCompact: Bool { hSize == .compact }
    private var horizontalPadding: CGFloat { isCompact ? 16 : 20 }

    private var level: (name: String, min: Int, max: Int) {
        let total = store.words.count
        switch total {
        case 0..<50: return ("Beginner 🐣", 0, 50)
        case 50..<150: return ("Explorer 🦊", 50, 150)
        case 150..<300: return ("Linguist 🦉", 150, 300)
        case 300..<600: return ("Master 🐉", 300, 600)
        default: return ("Legend 🌟", 600, 1000)
        }
    }

    private var progressToNextLevel: Double {
        let total = Double(store.words.count)
        let minVal = Double(level.min)
        let maxVal = Double(level.max)
        return min(1.0, (total - minVal) / (maxVal - minVal))
    }

    private var recentWords: [StoredWord] {
        Array(store.words.sorted(by: { $0.dateAdded > $1.dateAdded }).prefix(3))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                mainContent
                    .tabItem { icon(for: .home) }
                    .tag(Tab.home)

                DictionaryView()
                    .tabItem { icon(for: .list) }
                    .tag(Tab.list)

                Color.clear
                    .tabItem { icon(for: .add) }
                    .tag(Tab.add)
            }
            .tint(Color("MainBlack"))
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == .add {
                    selectedTab = oldValue ?? .home
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        showAddWordView = true
                    }
                }
            }
        }
        .sheet(isPresented: $showAddWordView) {
            AddWordView(store: store)
                .transaction { $0.disablesAnimations = true }
        }
    }

    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                ProfileHeaderView()

                StatsView()
                    .padding(.top, 4)

                if !recentWords.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recently added")
                            .font(.custom("Poppins-Bold", size: 22))
                            .foregroundColor(Color("MainBlack"))
                            .padding(.horizontal, horizontalPadding)

                        ForEach(recentWords) { word in
                            WordCardView(
                                word: word.word,
                                translation: word.translation,
                                type: word.type,
                                example: word.example,
                                comment: word.comment,
                                tag: word.tag
                            ) {
                                store.remove(word)
                            }
                            .padding(.horizontal, horizontalPadding)
                        }
                    }
                    .padding(.top, 8)
                } else {
                    Text("No recent words yet 😌")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color("MainGrey"))
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, 8)
                }
            }
            .padding(.bottom, 60)
        }
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .home:
            Image(systemName: "house")
        case .list:
            Image(systemName: "book.fill")
        case .add:
            Image(systemName: "plus.circle.fill")
        }
    }
}

#Preview {
    HomeView().environmentObject(WordsStore())
}
