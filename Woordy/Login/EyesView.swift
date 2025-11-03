import SwiftUI

struct EyesView: View {
    @State private var isBlinking = false
    @State private var blinkTimer: Timer?
    @State private var lookTimer: Timer?
    @State private var lookOffset: CGPoint = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {

                HStack(spacing: 75) {
                    EyeView(lookOffset: $lookOffset,
                            parentSize: geo.size,
                            isBlinking: $isBlinking)
                    EyeView(lookOffset: $lookOffset,
                            parentSize: geo.size,
                            isBlinking: $isBlinking)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                startBlinking()
                startLooking()
            }
            .onDisappear {
                blinkTimer?.invalidate()
                lookTimer?.invalidate()
            }
        }
    }

    private func startBlinking() {
        blinkTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 2.5...5.0), repeats: true) { _ in
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

    private func startLooking() {
        lookTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 1.5...2.5), repeats: true) { _ in
            let radius: CGFloat = 10
            let deadZoneX: CGFloat = 3
            let side: CGFloat = Bool.random() ? -1 : 1
            let xMag = CGFloat.random(in: deadZoneX...radius)
            let x = side * xMag
            let maxY = sqrt(max(0, radius*radius - xMag*xMag))
            let y = CGFloat.random(in: -min(4, maxY)...min(4, maxY))
            withAnimation(.easeInOut(duration: 0.35)) {
                lookOffset = CGPoint(x: x, y: y)
            }
        }
    }
}

struct EyeView: View {
    @Binding var lookOffset: CGPoint
    var parentSize: CGSize
    @Binding var isBlinking: Bool

    var body: some View {
        GeometryReader { geo in
            let offsetX = max(min(lookOffset.x, 10), -10)
            let offsetY = max(min(lookOffset.y, 10), -10)

            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 140, height: 140)
                    .shadow(radius: 3)

                Circle()
                    .fill(Color.black)
                    .frame(width: 105, height: 105)
                    .offset(x: offsetX, y: offsetY)
                    .animation(.easeInOut(duration: 0.35), value: lookOffset)
            }
            .scaleEffect(y: isBlinking ? 0.05 : 1.0)
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    EyesView()
}
