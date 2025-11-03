//
//  PopularTagsView.swift
//  Woordy
//
//  Created by Iurii Naumov on 11/2/25.
//


import SwiftUI

struct PopularTagsView: View {
    @State private var selectedTag: String? = nil
    
    // Цвета — взяты с твоего скрина
    let tags: [(name: String, color: Color)] = [
        ("Social", Color(hex: 0xE6D3F1)),     // Lavender
        ("Chat/DM", Color(hex: 0xF3CDE0)),   // Pink
        ("Apps/UI", Color(hex: 0xBFDFF1)),   // Light Blue
        ("Street", Color(hex: 0xA9D9DD)),    // Teal
        ("Movies", Color(hex: 0xD9E764)),    // Lime
        ("Travel", Color(hex: 0xFF9387))     // Coral
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular tags")
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(.black)
                .padding(.horizontal, 8)
            
            // MARK: Горизонтальный список
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(tags, id: \.name) { tag in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTag = (selectedTag == tag.name) ? nil : tag.name
                            }
                        } label: {
                            Text(tag.name)
                                .font(.custom("Poppins-Medium", size: 15))
                                .foregroundColor(.black)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(tag.color)
                                        .opacity(selectedTag == tag.name ? 1 : 0.7)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(selectedTag == tag.name ? Color.black.opacity(0.2) : .clear, lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(selectedTag == tag.name ? 0.1 : 0), radius: 4, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

// MARK: - Цвет из HEX
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

#Preview {
    PopularTagsView()
        .padding()
        .background(Color.white)
}