//
//  Message.swift
//  Atmos
//
//  Created by Michael Amiro on 22/01/2025.
//

import Foundation
import SwiftUI

struct Message {
    let text: String
    let type: MessageType

    init(text: String, type: MessageType = .error) {
        self.text = text
        self.type = type
    }
}

enum MessageType {
    case info
    case warning
    case error

    var icon: String {
        switch self {
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "exclamationmark.octagon.fill"
        }
    }

    var background: Color {
        switch self {
        case .info:
            return Color.blue.opacity(0.3)
        case .warning:
            return Color.orange.opacity(0.3)
        case .error:
            return Color.red.opacity(0.3)
        }
    }
}

struct ShowMessageAction {
    let action: (String, MessageType) -> Void

    func callAsFunction(message: String, type: MessageType = .error) {
        action(message, type)
    }
}
