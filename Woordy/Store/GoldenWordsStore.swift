import Foundation
import SwiftUI
import Combine

struct SuggestedWord: Identifiable, Equatable {
    let id = UUID()
    let word: String
    let translation: String
}

@MainActor
final class GoldenWordsStore: ObservableObject {
    @Published var goldenWords: [SuggestedWord] = []
    @Published var isLoading = false
    @Published var lastXPReward: Int?

    func fetchSuggestions(basedOn words: [StoredWord]) async {
        isLoading = true
        defer { isLoading = false }

        let samples = [
            SuggestedWord(word: "aventura", translation: "adventure"),
            SuggestedWord(word: "descubrir", translation: "to discover"),
            SuggestedWord(word: "sabroso", translation: "tasty"),
            SuggestedWord(word: "maravilla", translation: "wonder")
        ]
        goldenWords = Array(samples.shuffled().prefix(2))
    }

    func accept(_ word: SuggestedWord, store: WordsStore) {
        let newWord = StoredWord(
            word: word.word,
            type: "существительное",
            translation: word.translation,
            example: "—",
            comment: nil,
            tag: "Golden"
        )

        store.add(newWord)
        goldenWords.removeAll { $0.id == word.id }
    }

    func skip(_ suggestion: SuggestedWord) {
        goldenWords.removeAll { $0.id == suggestion.id }
    }
}
