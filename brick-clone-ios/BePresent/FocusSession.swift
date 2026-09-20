import Foundation

/// Persistent session policy, independent of NFC and Screen Time frameworks.
struct FocusSession: Codable, Equatable {
    private(set) var pairedTag: String?
    private(set) var startedAt: Date?
    var isBlocking: Bool { startedAt != nil }

    mutating func scan(tag: String, hasSelection: Bool, now: Date = Date()) throws {
        guard !tag.isEmpty else { throw ScanError.invalidTag }
        if let pairedTag, pairedTag != tag { throw ScanError.wrongTag }
        if isBlocking {
            startedAt = nil
        } else {
            guard hasSelection else { throw ScanError.noSelection }
            pairedTag = tag
            startedAt = now
        }
    }

    enum ScanError: LocalizedError {
        case invalidTag, wrongTag, noSelection
        var errorDescription: String? {
            switch self {
            case .invalidTag: return "This tag could not be identified. Try another NFC tag."
            case .wrongTag: return "That isn’t your paired device. Scan the same device you used for your first session."
            case .noSelection: return "Choose at least one app, category, or website before starting."
            }
        }
    }
}
