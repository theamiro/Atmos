//
//  MessageView.swift
//  Atmos
//
//  Created by Michael Amiro on 22/01/2025.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    var body: some View {
        HStack(spacing: 20) {
            Text(message.text)
                .font(.subheadline)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: message.type.icon)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(message.type.background)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

#Preview {
    MessageView(message: Message(text: "An error occurred and you cannot proceed"))
    MessageView(message: Message(text: "Something seems to be going wrong but you're still good", type: .warning))
    MessageView(message: Message(text: "This is just to let you know of something", type: .info))
}
