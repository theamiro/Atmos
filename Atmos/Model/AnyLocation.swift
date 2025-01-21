//
//  AnyLocation.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Foundation
import CoreLocation

protocol AnyLocation: Identifiable, Equatable, Hashable {
    var id: UUID { get }
    var name: String? { get set }
    var longitude: Double { get set }
    var latitude: Double { get set }

    var coordinate2D: CLLocationCoordinate2D { get }

    static func == (lhs: Self, rhs: Self) -> Bool
}

extension AnyLocation {
    var id: UUID { UUID() }

    var coordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct Location: AnyLocation {
    var id: UUID = UUID()
    var name: String?
    var longitude: Double
    var latitude: Double
}
