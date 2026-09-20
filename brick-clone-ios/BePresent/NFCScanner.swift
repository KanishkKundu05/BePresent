import CoreNFC
import Foundation

/// Delegate callbacks and completion are delivered on the main queue.
final class NFCScanner: NSObject, NFCTagReaderSessionDelegate {
    private var session: NFCTagReaderSession?
    private var completion: ((Result<String, Error>) -> Void)?

    func scan(completion: @escaping (Result<String, Error>) -> Void) {
        guard session == nil else { return }
        guard NFCTagReaderSession.readingAvailable else {
            completion(.failure(ReaderError.unavailable))
            return
        }
        self.completion = completion
        session = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693], delegate: self, queue: .main)
        session?.alertMessage = "Hold the top of your iPhone against your BePresent device."
        session?.begin()
    }

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard tags.count == 1, let tag = tags.first else {
            session.alertMessage = "More than one tag detected. Hold your phone near just your BePresent device."
            session.restartPolling()
            return
        }
        session.connect(to: tag) { [weak self] error in
            DispatchQueue.main.async {
                guard let self, self.completion != nil else { return }
                if let error {
                    self.finish(.failure(error))
                    session.invalidate(errorMessage: "Couldn’t read the device. Please try again.")
                    return
                }
                let identifier: String
                switch tag {
                case .miFare(let tag): identifier = "mifare:" + tag.identifier.hex
                case .iso15693(let tag): identifier = "iso15693:" + tag.identifier.hex
                default:
                    self.finish(.failure(ReaderError.unsupported))
                    session.invalidate(errorMessage: "Use a compatible MIFARE or ISO 15693 tag.")
                    return
                }
                session.alertMessage = "Device read."
                self.finish(.success(identifier))
                session.invalidate()
            }
        }
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        self.session = nil
        finish(.failure(error))
    }

    private func finish(_ result: Result<String, Error>) {
        let callback = completion
        completion = nil
        callback?(result)
    }

    enum ReaderError: LocalizedError {
        case unavailable, unsupported
        var errorDescription: String? {
            switch self {
            case .unavailable: return "NFC scanning requires a compatible physical iPhone. It isn’t available in the simulator."
            case .unsupported: return "Use a compatible MIFARE tag, such as NTAG213/215/216, or an ISO 15693 tag."
            }
        }
    }
}

private extension Data {
    var hex: String { map { String(format: "%02x", $0) }.joined() }
}
