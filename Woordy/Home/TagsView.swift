import SwiftUI

struct TagsView: View {
    @Binding var selectedTag: String?
    
    let tags: [(name: String, color: Color)] = [
        ("Social", .init(hex: 0xF2D0F9)),
        ("Chat", .init(hex: 0xB3D9ED)),
        ("Apps", .init(hex: 0xD9E764)),
        ("Street", .init(hex: 0xFFD7A8)),
        ("Movies", .init(hex: 0xD9E764)),
        ("Travel", .init(hex: 0xFF9387))
    ]
    
    var body: some View {
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
                                tag.color.opacity(selectedTag == tag.name ? 1.0 : 0.7)
                            )
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        selectedTag == tag.name
                                        ? tag.color.darker(by: 0.3)
                                        : .clear,
                                        lineWidth: 1.5
                                    )
                            )
                            .scaleEffect(selectedTag == tag.name ? 1.12 : 1)
                            .animation(.easeInOut(duration: 0.3), value: selectedTag)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
        }
    }
}

// MARK: - Color extension
extension Color {
    init(hexRGB: UInt, alpha: Double = 1.0) {
        let r = Double((hexRGB >> 16) & 0xFF) / 255.0
        let g = Double((hexRGB >> 8) & 0xFF) / 255.0
        let b = Double(hexRGB & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
    
    func darker(by percentage: Double = 0.2) -> Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color(
            .sRGB,
            red: Double(max(red - CGFloat(percentage), 0)),
            green: Double(max(green - CGFloat(percentage), 0)),
            blue: Double(max(blue - CGFloat(percentage), 0)),
            opacity: Double(alpha)
        )
    }
}

#Preview {
    // Пример превью с моковым состоянием
    StatefulPreviewWrapper<String?>(nil) { selectedTag in
        TagsView(selectedTag: selectedTag)
            .padding()
            .background(Color.white)
    }
}

// Универсальный обёртка для превью с @Binding
struct StatefulPreviewWrapper<Value>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> any View

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        AnyView(content($value))
    }
}
