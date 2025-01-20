//
//  AnyLocation.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Foundation

protocol AnyLocation: Identifiable, Equatable, Hashable {
    var id: UUID { get }
    var longitude: Double { get set }
    var latitude: Double { get set }

    static func == (lhs: Self, rhs: Self) -> Bool
}

extension AnyLocation {
    var id: UUID { UUID() }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct Location: AnyLocation {
    var id: UUID = UUID()
    var longitude: Double
    var latitude: Double
}
