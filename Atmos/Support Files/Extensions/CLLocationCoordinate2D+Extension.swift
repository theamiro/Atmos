//
//  CLLocationCoordinate2D+Extension.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func isSignificantlyDifferent(from location: Self, radius: Double = 5_000) -> Bool {
        let currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let otherLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let distance = currentLocation.distance(from: otherLocation)
        return distance > radius
    }
}
