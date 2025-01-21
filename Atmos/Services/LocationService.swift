//
//  LocationService.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import Combine
import Foundation

protocol LocationServiceDelegate: AnyObject {
    func getGeoCodePlaceName(location: any AnyLocation) -> AnyPublisher<[GeoCodeAddress], Error>
}

final class LocationService: LocationServiceDelegate {
    private let baseURL = "https://maps.googleapis.com"
    private var token = Bundle.main.infoDictionary?["GOOGLE_MAPS_API_KEY"] as? String ?? "Unknown"

    private var networkClient: NetworkClientDelegate

    init(networkClient: NetworkClientDelegate = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getGeoCodePlaceName(location: any AnyLocation) -> AnyPublisher<[GeoCodeAddress], Error> {
        let parameters: [String: Any] = [
            "latlng": [location.latitude, location.longitude]
        ]
        let target = Target(
            baseURL: baseURL,
            path: "/maps/api/geocode/json",
            authorizationType: .queryParameter(key: "key", value: token),
            task: .queryParameters(parameters)
        )
        return networkClient.request(target).map(\GeoCodeResponse.results).eraseToAnyPublisher()
    }
}
