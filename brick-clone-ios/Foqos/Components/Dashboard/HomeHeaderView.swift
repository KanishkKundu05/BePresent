import SwiftUI

struct HomeHeaderView: View {
  let onSupportTapped: () -> Void
  let onSettingsTapped: () -> Void
  var showsSupportTitle = true
  var titleFont: Font = .largeTitle

  var body: some View {
    HStack(alignment: .center) {
      AppTitle(font: titleFont)
        .lineLimit(2)
      Spacer()
      HStack(spacing: 8) {
        RoundedButton(
          showsSupportTitle ? "About" : "",
          action: onSupportTapped,
          textColor: .white,
          iconName: "info.circle"
        )
        .accessibilityLabel("About BePresent")
        RoundedButton("", action: onSettingsTapped, textColor: .white, iconName: "gear")
          .accessibilityLabel("Settings")
      }
    }
    .padding(.trailing, 16)
    .padding(.vertical, 24)
    .foregroundStyle(.white)
    .background(Color(hex: "#1736F5"))
    .environment(\.colorScheme, .dark)
  }
}

#Preview {
  HomeHeaderView(onSupportTapped: {}, onSettingsTapped: {})
}

#Preview("Sidebar") {
  HomeHeaderView(
    onSupportTapped: {}, onSettingsTapped: {}, showsSupportTitle: false, titleFont: .title2
  )
  .frame(width: 280)
}
