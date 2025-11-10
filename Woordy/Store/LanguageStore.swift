import SwiftUI
import Combine

final class LanguageStore: ObservableObject {
    @Published var nativeLanguage: String = "Русский"
    @Published var learningLanguage: String = "Español"
}
