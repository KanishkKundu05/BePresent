import AppIntents
import SwiftData

struct StopProfileIntent: AppIntent {
  @Dependency(key: "ModelContainer")
  private var modelContainer: ModelContainer

  @MainActor
  private var modelContext: ModelContext {
    return modelContainer.mainContext
  }

  @Parameter(title: "Profile") var profile: BlockedProfileEntity

  static var title: LocalizedStringResource = "Stop BePresent Profile"

  static var parameterSummary: some ParameterSummary {
    Summary("Stop \(\.$profile)")
  }

  static var description = IntentDescription(
    "Stop a BePresent blocking profile."
  )

  @MainActor
  func perform() async throws -> some IntentResult {
    let strategyManager = StrategyManager.shared

    strategyManager
      .stopSessionFromBackground(
        profile.id,
        context: modelContext
      )

    return .result()
  }
}
