import SwiftUI

struct TagsView: View {
    @Binding var selectedTag: String?
    var compact: Bool = false

    static let allTags: [(name: String, color: Color)] = [
        ("Social", Color(hexRGB: 0xFFDFA4)),
        ("Chat",   Color(hexRGB: 0xB9E3FF)),
        ("Apps",   Color(hexRGB: 0xC6F6D5)),
        ("Street", Color(hexRGB: 0xFFC6C9)),
        ("Movies", Color(hexRGB: 0xE4D2FF)),
        ("Travel", Color(hexRGB: 0xFFF1B2)),
        ("Work",   Color(hexRGB: 0xBDF4F2))
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: compact ? 10 : 14) {
                ForEach(Self.allTags, id: \.name) { tag in
                    let isSelected = selectedTag == tag.name
                    let baseColor = tag.color
                    let darkerText = darkerShade(of: tag.color, by: 0.35)

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTag = isSelected ? nil : tag.name
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text(tag.name)
                                .font(.custom("Poppins-Medium", size: compact ? 13 : 15))
                                .foregroundColor(isSelected ? darkerText : Color("MainBlack"))
                        }
                        .frame(minWidth: 100)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(baseColor.opacity(isSelected ? 1.0 : 0.25))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(baseColor.opacity(isSelected ? 0.45 : 0.35), lineWidth: 1.5)
                        )
                        .shadow(color: baseColor.opacity(isSelected ? 0.4 : 0.25),
                                radius: isSelected ? 8 : 5,
                                x: 0, y: isSelected ? 4 : 2)
                        .scaleEffect(isSelected ? 1.05 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, compact ? 10 : 16)
            .padding(.vertical, compact ? 6 : 10)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        Text("Select a Tag")
            .font(.custom("Poppins-Bold", size: 22))
            .foregroundColor(Color("MainBlack"))
            .padding(.horizontal)

        TagsView(selectedTag: .constant(nil))
        TagsView(selectedTag: .constant("Travel"))

        Spacer()
    }
    .padding(.vertical, 30)
    .background(Color(hexRGB: 0xFFF8E7))
}
