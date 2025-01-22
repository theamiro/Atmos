//
//  LogService.swift
//  Atmos
//
//  Created by Michael Amiro on 22/01/2025.
//

import os
import Logging
import Foundation

let log: Logging.Logger = {
    let osLogHandler = OSLogHandler()
    let multiplexLogHandler = MultiplexLogHandler([osLogHandler])
    return Logger(label: Bundle.main.bundleIdentifier!) { _ in multiplexLogHandler }
}()

private final class OSLogHandler: LogHandler {
    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[key] }
        set(newValue) { metadata[key] = newValue }
    }

    var metadata = Logging.Logger.Metadata()
    var logLevel = Logging.Logger.Level.debug

    private let osLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "app")

    func log(level: Logging.Logger.Level,
             message: Logging.Logger.Message,
             metadata: Logging.Logger.Metadata?,
             source: String,
             file: String,
             function: String,
             line: UInt) {
        let filename = URL(fileURLWithPath: file).lastPathComponent
        os_log("[%@: %d]\n%{public}@%@",
               log: osLog,
               filename,
               line,
               message.description,
               metadata?.description ?? "")
    }
}
