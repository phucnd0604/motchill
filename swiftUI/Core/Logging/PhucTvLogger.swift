import Foundation
import SwiftyBeaver

final class PhucTvLogger: @unchecked Sendable {
    static let shared = PhucTvLogger()

    private var isConfigured = false

    private init() {
        configureIfNeeded()
    }

    func debug(
        _ message: String,
        metadata: [String: String] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        logMessage(message: message, metadata: metadata, level: .debug, file: file, function: function, line: line)
    }

    func info(
        _ message: String,
        metadata: [String: String] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        logMessage(message: message, metadata: metadata, level: .info, file: file, function: function, line: line)
    }

    func warning(
        _ message: String,
        metadata: [String: String] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        logMessage(message: message, metadata: metadata, level: .warning, file: file, function: function, line: line)
    }

    func error(
        _ error: Error,
        message: String,
        metadata: [String: String] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        var combinedMetadata = metadata
        combinedMetadata["error"] = String(describing: error)
        logMessage(message: message, metadata: combinedMetadata, level: .error, file: file, function: function, line: line)
    }

    func logMessage(
        message: String,
        metadata: [String: String] = [:],
        level: SwiftyBeaver.Level,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        configureIfNeeded()

        let metadataText = metadata
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: " ")

        let formattedMessage = metadataText.isEmpty ? message : "\(message) | \(metadataText)"

        switch level {
        case .debug:
            SwiftyBeaver.debug(formattedMessage, file: file, function: function, line: line)
        case .info:
            SwiftyBeaver.info(formattedMessage, file: file, function: function, line: line)
        case .warning:
            SwiftyBeaver.warning(formattedMessage, file: file, function: function, line: line)
        case .error:
            SwiftyBeaver.error(formattedMessage, file: file, function: function, line: line)
        case .verbose:
            SwiftyBeaver.verbose(formattedMessage, file: file, function: function, line: line)
        case .critical:
            SwiftyBeaver.critical(formattedMessage, file: file, function: function, line: line)
        case .fault:
            SwiftyBeaver.fault(formattedMessage, file: file, function: function, line: line)
        }
    }

    private func configureIfNeeded() {
        guard !isConfigured else {
            return
        }

        let console = ConsoleDestination()
        console.asynchronously = false
        console.useTerminalColors = true
        console.minLevel = .verbose
        console.format = "$DHH:mm:ss.SSS$d $L $N.$F:$l - $M"

        SwiftyBeaver.addDestination(console)
        isConfigured = true
    }
}
