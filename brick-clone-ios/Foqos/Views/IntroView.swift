import SwiftUI

struct IntroView: View {
  let onRequestAuthorization: () -> Void

  var body: some View {
    AnimatedIntroContainer(
      onRequestAuthorization: onRequestAuthorization
    )
    .background(Color(hex: "#1736F5").ignoresSafeArea())
    .preferredColorScheme(.dark)
  }
}

#Preview {
  IntroView {
    print("Request authorization tapped")
  }
  .environmentObject(ThemeManager.shared)
}
