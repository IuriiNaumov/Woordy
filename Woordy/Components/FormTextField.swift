import SwiftUI
import Combine

struct FormTextField: View {
    let title: String
    @Binding var text: String
    var focusedColor: Color = Color("MainBlack")
    var maxLength: Int? = nil
    var showCounter: Bool = false

    @FocusState private var isFocused: Bool

    private let counterFont = Font.custom("Poppins-Regular", size: 13)

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(title, text: $text)
                .focused($isFocused)
                .onReceive(Just(text)) { newValue in
                    if let limit = maxLength, newValue.count > limit {
                        text = String(newValue.prefix(limit))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 19)
                .background(Color(hexRGB: 0xF8F8F8))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isFocused ? focusedColor : .clear, lineWidth: 1.5)
                        .animation(.easeInOut(duration: 0.2), value: isFocused)
                )
                .font(.custom("Poppins-Regular", size: 16))
                .foregroundColor(Color("MainBlack"))

            if showCounter, let limit = maxLength {
                Text("\(text.count)/\(limit)")
                    .font(counterFont)
                    .foregroundColor(Color("MainGrey"))
                    .padding(.trailing, 14)
            }
        }
    }
}
