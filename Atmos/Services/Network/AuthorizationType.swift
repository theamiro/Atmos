//
//  AuthorizationType.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation

enum AuthorizationType {
    case bearer(token: String)
    case queryParameter(key: String, value: String = Bundle.main.infoDictionary?["API_KEY"] as? String ?? "Unknown")
    case none
}
