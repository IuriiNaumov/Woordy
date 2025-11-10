import SwiftUI
import AVFoundation

@main
struct WoordyApp: App {
    @StateObject private var store = WordsStore()
    @StateObject private var golden = GoldenWordsStore()
    @StateObject private var languageStore = LanguageStore()

    init() {
        warmUpKeyboard()
        warmUpAudioSession()
        warmUpGPT()
        preloadFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(golden)
                .environmentObject(languageStore)
        }
    }

    private func warmUpKeyboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let textField = UITextField()
            UIApplication.shared.windows.first?.addSubview(textField)
            textField.becomeFirstResponder()
            textField.resignFirstResponder()
            textField.removeFromSuperview()
        }
    }

    private func warmUpAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback)
        try? session.setActive(true)
    }

    private func warmUpGPT() {
        Task.detached(priority: .background) {
            let languageStore = LanguageStore()
            _ = try? await translateWithGPT(word: "hola", languageStore: languageStore)
        }
    }

    private func preloadFonts() {
        _ = UIFont(name: "Poppins-Bold", size: 14)
        _ = UIFont(name: "Poppins-Regular", size: 14)
    }
}
