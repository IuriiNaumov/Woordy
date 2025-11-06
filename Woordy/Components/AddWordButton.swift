import SwiftUI

struct AddWordButton: View {
    let title: String
    let isDisabled: Bool
    let action: () async throws -> Void
    var onSuccess: (() -> Void)? = nil
    var onError: ((Error) -> Void)? = nil

    @State private var isLoading = false
    @State private var errorMessage: String?

    private let mainColor = Color("MainBlack")
    private let darkerColor = Color(hexRGB: 0x7ACFA3)

    var body: some View {
        VStack(spacing: 8) {
            Button {
                if !isLoading && !isDisabled {
                    Task { await performAction() }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .fill(isDisabled ? mainColor.opacity(0.5) : mainColor)
                        .frame(height: 58)
                        .shadow(color: mainColor.opacity(0.45), radius: 8, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50, style: .continuous)
                                .stroke(mainColor.opacity(0.7), lineWidth: 1.5)
                        )

                    if isLoading {
                        Loader()
                    } else {
                        Text(title)
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.4), radius: 1, x: 0, y: 1)
                    }
                }
                .scaleEffect(isLoading ? 0.98 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isLoading)
            }
            .disabled(isDisabled || isLoading)
            .buttonStyle(.plain)
            .padding(.horizontal, 10)

            if let message = errorMessage {
                Text(message)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color("MainGrey"))
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: errorMessage)
    }

    private func performAction() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            try await action()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            onSuccess?()
        } catch {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            withAnimation {
                errorMessage = "Something went wrong. Try again."
            }
            onError?(error)
        }

        isLoading = false
    }
}

#Preview {
    VStack(spacing: 24) {
        AddWordButton(
            title: "Add Word",
            isDisabled: false
        ) { }

        AddWordButton(
            title: "Disabled",
            isDisabled: true
        ) { }
    }
    .padding()
    .background(Color(hexRGB: 0xFFF8E7))
}
