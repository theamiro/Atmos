//
//  MockPlacesService.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import Foundation
import Combine

class MockPlacesService: PlacesServiceDelegate {
    func getGeoCodePlaceName(latitude: Double, longitude: Double) -> AnyPublisher<[GeoCodeAddress], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func searchPlacesByText(text: String) -> AnyPublisher<[Place], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
