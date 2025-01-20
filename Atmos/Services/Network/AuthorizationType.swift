//
//  AuthorizationType.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation

enum AuthorizationType {
    case bearer
    case queryParameter(key: String)
    case none
}
