import CoreNFC
import FamilyControls
import ManagedSettings
import SwiftUI

@MainActor
final class FocusController: ObservableObject {
    @Published private(set) var session: FocusSession
    @Published var selection: FamilyActivitySelection
    @Published private(set) var authorized = false
    @Published private(set) var busy = false
    @Published var errorMessage: String?

    private let defaults = UserDefaults.standard
    private let store = ManagedSettingsStore(named: .init("BePresent"))
    private let scanner = NFCScanner()

    init() {
        session = Self.restore(FocusSession.self, key: "focusSession") ?? FocusSession()
        selection = Self.restore(FamilyActivitySelection.self, key: "activitySelection") ?? FamilyActivitySelection()
        refreshAuthorization()
    }

    var selectionCount: Int {
        selection.applicationTokens.count + selection.categoryTokens.count + selection.webDomainTokens.count
    }

    func requestAccess() async {
        busy = true
        defer { busy = false }
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            refreshAuthorization()
        } catch { errorMessage = "Screen Time access wasn’t enabled. \(error.localizedDescription)" }
    }

    func refreshAuthorization() {
        authorized = AuthorizationCenter.shared.authorizationStatus == .approved
        if authorized { applyShields() }
    }

    func saveSelection() {
        persist(selection, key: "activitySelection")
        if authorized { applyShields() }
    }

    func scan() {
        refreshAuthorization()
        guard !busy else { return }
        guard authorized else {
            errorMessage = "Enable Screen Time access before scanning your device."
            return
        }
        guard session.isBlocking || selectionCount > 0 else {
            errorMessage = FocusSession.ScanError.noSelection.localizedDescription
            return
        }
        busy = true
        scanner.scan { [weak self] result in
            guard let self else { return }
            self.busy = false
            switch result {
            case .success(let identifier):
                guard AuthorizationCenter.shared.authorizationStatus == .approved else {
                    self.refreshAuthorization()
                    self.errorMessage = "Screen Time access changed. Enable access and try again."
                    return
                }
                do {
                    try self.session.scan(tag: identifier, hasSelection: self.selectionCount > 0)
                    self.persist(self.session, key: "focusSession")
                    self.applyShields()
                } catch { self.errorMessage = error.localizedDescription }
            case .failure(let error):
                if (error as? NFCReaderError)?.code != .readerSessionInvalidationErrorUserCanceled {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func applyShields() {
        guard session.isBlocking else {
            store.clearAllSettings()
            return
        }
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
        store.shield.webDomainCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
    }

    private func persist<T: Encodable>(_ value: T, key: String) {
        do { defaults.set(try JSONEncoder().encode(value), forKey: key) }
        catch { errorMessage = "Couldn’t save your session. \(error.localizedDescription)" }
    }

    private static func restore<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
