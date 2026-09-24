import SwiftUI

struct SupportView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          Text("be\npresent")
            .font(.system(size: 56, weight: .heavy, design: .rounded))
            .lineSpacing(-10)
          Text("Your time. Back in your hands.")
            .font(.title2.bold())
          Text("BePresent helps you create space from distracting apps with NFC tags, QR codes, schedules, and focused routines.")
          Link("BePresent source code", destination: URL(string: "https://github.com/KanishkKundu05/BePresent")!)
            .underline()
          Divider().overlay(.white.opacity(0.4))
          Text("Open-source foundation")
            .font(.headline)
          Text("Built on Foqos by Ali Waseem. Its blocking engine and system integrations are used under the MIT license.")
          Link("View Foqos and its MIT license", destination: URL(string: "https://github.com/awaseem/foqos/blob/main/LICENSE")!)
            .underline()
          if let licenseURL = Bundle.main.url(forResource: "LICENSE", withExtension: "txt"),
            let license = try? String(contentsOf: licenseURL, encoding: .utf8)
          {
            DisclosureGroup("MIT License") {
              Text(license)
                .font(.caption)
                .textSelection(.enabled)
                .padding(.top, 12)
            }
          }
        }
        .padding(28)
      }
      .foregroundStyle(.white)
      .tint(.white)
      .background(Color(hex: "#1736F5").ignoresSafeArea())
      .navigationTitle("About BePresent")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") { dismiss() }
        }
      }
      .toolbarBackground(Color(hex: "#1736F5"), for: .navigationBar)
      .toolbarColorScheme(.dark, for: .navigationBar)
    }
  }
}
