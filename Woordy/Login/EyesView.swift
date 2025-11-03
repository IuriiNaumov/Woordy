import SwiftUI

struct EyesView: View {
    // Точка, куда "смотрят" глаза
    @State private var gazePoint: CGPoint = .zero
    // Для анимации моргания
    @State private var isBlinking = false
    // Для задержки между морганиями
    @State private var blinkTimer: Timer?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                gazePoint = value.location
                            }
                    )

                HStack(spacing: 25) {
                    EyeView(gazePoint: $gazePoint,
                            parentSize: geo.size,
                            isBlinking: $isBlinking)
                    EyeView(gazePoint: $gazePoint,
                            parentSize: geo.size,
                            isBlinking: $isBlinking)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                startBlinking()
            }
            .onDisappear {
                blinkTimer?.invalidate()
            }
        }
    }

    private func startBlinking() {
        blinkTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.15)) {
                isBlinking = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isBlinking = false
                }
            }
        }
    }
}

struct EyeView: View {
    @Binding var gazePoint: CGPoint
    var parentSize: CGSize
    @Binding var isBlinking: Bool

    var body: some View {
        GeometryReader { geo in
            let eyeCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let dx = gazePoint.x - parentSize.width / 2
            let dy = gazePoint.y - parentSize.height / 2

            // ограничиваем смещение зрачка в пределах глаза
            let limit: CGFloat = 10
            let distance = sqrt(dx * dx + dy * dy)
            let ratio = min(distance == 0 ? 0 : limit / distance, 1)
            let offsetX = dx * ratio
            let offsetY = dy * ratio

            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                    .shadow(radius: 3)

                Circle()
                    .fill(Color.black)
                    .frame(width: 25, height: 25)
                    .offset(x: offsetX, y: offsetY)
                    .animation(.easeOut(duration: 0.15), value: gazePoint)
            }
            // моргание — сжимаем глаз по вертикали
            .scaleEffect(y: isBlinking ? 0.05 : 1.0)
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    EyesView()
}