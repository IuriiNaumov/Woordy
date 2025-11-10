import SwiftUI

struct ContentView: View {
    @StateObject private var store = WordsStore()
    @StateObject private var languageStore = LanguageStore()

    var body: some View {
        HomeView()
            .environmentObject(store).environmentObject(languageStore)
    }
}

#Preview {
    ContentView()
}
