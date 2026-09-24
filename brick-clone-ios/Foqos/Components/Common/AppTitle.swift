import SwiftUI

struct AppTitle: View {
  let title: String
  let font: Font
  let fontWeight: Font.Weight
  let horizontalPadding: CGFloat

  init(
    _ title: String = "BePresent",
    font: Font = .largeTitle,
    fontWeight: Font.Weight = .bold,
    horizontalPadding: CGFloat = 16
  ) {
    self.title = title
    self.font = font
    self.fontWeight = fontWeight
    self.horizontalPadding = horizontalPadding
  }

  var body: some View {
    Text(title == "BePresent" ? "be\npresent" : title)
      .font(font)
      .fontDesign(.rounded)
      .lineSpacing(-6)
      .fixedSize(horizontal: false, vertical: true)
      .fontWeight(fontWeight)
      .padding(.horizontal, horizontalPadding)
  }
}

// Preview
#Preview {
  VStack(spacing: 24) {
    AppTitle()

    AppTitle("BePresent", font: .title, fontWeight: .semibold)

    AppTitle("Custom Title", font: .title2, fontWeight: .medium, horizontalPadding: 24)
  }
  .padding(20)
}
