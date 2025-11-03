import SwiftUI
import AVFoundation

struct HomeView: View {
    @State private var selectedCategory: String = "Slang"
    @State private var selectedSourceTag: String? = nil
    
    let categories = [
        ("Slang", Color(hexRGB: 0xE6D3F1)),
        ("Favorites", Color(hexRGB: 0xCDE4F3)),
        ("Movies", Color(hexRGB: 0xDDE77D))
    ]
    
    let words: [WordCard] = [
        WordCard(category: "Slang", title: "Sabroso", type: "noun", translation: "Вкусный", color: Color(hexRGB: 0xE6D3F1)),
        WordCard(category: "Favorites", title: "Chido", type: "noun", translation: "Круто", color: Color(hexRGB: 0xCDE4F3))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("Hey, Yura")
                            .font(.custom("Poppins-Bold", size: 28))
                        Text("👋")
                    }
                    Text("Good morning")
                        .font(.custom("Poppins-Regular", size: 15))
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // MARK: - Categories
            HStack(spacing: 12) {
                ForEach(categories, id: \.0) { category, color in
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(color)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.black.opacity(selectedCategory == category ? 0.15 : 0), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            Text("You have \(words.count) words")
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(words) { word in
                        WordCardView(
                            word: word.title,
                            translation: word.translation,
                            type: word.type,
                            category: word.category,
                            categoryColor: word.color
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 90)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                HStack(spacing: 36) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 28, height: 28)
                    Image(systemName: "trophy")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 28, height: 28)
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 28, height: 28)
                }
                .foregroundColor(.black)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(hexRGB: 0xA78BFA))
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, y: 2)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct WordCard: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let type: String?
    let translation: String?
    let color: Color
}

extension Color {
    init(hexRGB: UInt, alpha: Double = 1.0) {
        let r = Double((hexRGB >> 16) & 0xFF) / 255.0
        let g = Double((hexRGB >> 8) & 0xFF) / 255.0
        let b = Double(hexRGB & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

#Preview {
    HomeView()
}
