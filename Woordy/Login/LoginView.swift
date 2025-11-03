import SwiftUI
import UIKit

struct LoginView: View {
    var body: some View {
        VStack {
            Image("Face").resizable().scaledToFit().frame(width: 400, height: 300)
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 420)
        .background(Color("FaceColor"))
        .clipShape(RoundedCorners(radius: 40, corners: [.bottomLeft, .bottomRight]))
        
        Spacer()
    }
}

#Preview {
    LoginView()
}

struct RoundedCorners: Shape {
    var radius: CGFloat = 16.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
