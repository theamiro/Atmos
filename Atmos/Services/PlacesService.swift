//
//  PlacesService.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import Foundation
import Combine

protocol PlacesServiceDelegate: AnyObject {
    func getGeoCodePlaceName(latitude: Double, longitude: Double) -> AnyPublisher<[GeoCodeAddress], Error>
    func searchPlacesByText(text: String) -> AnyPublisher<[Place], Error>
}

class GooglePlacesService: PlacesServiceDelegate {
    private var token = Bundle.main.infoDictionary?["GOOGLE_MAPS_API_KEY"] as? String ?? "Unknown"

    private let networkClient: NetworkClientDelegate

    init(networkClient: NetworkClientDelegate = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getGeoCodePlaceName(latitude: Double, longitude: Double) -> AnyPublisher<[GeoCodeAddress], Error> {
        let parameters: [String: Any] = [
            "latlng": [latitude, longitude]
        ]
        let target = Target(
            baseURL: "https://maps.googleapis.com",
            path: "/maps/api/geocode/json",
            authorizationType: .queryParameter(key: "key", value: token),
            task: .queryParameters(parameters)
        )
        return networkClient.request(target)
            .receive(on: DispatchQueue.main)
            .map(\GeoCodeResponse.results)
            .eraseToAnyPublisher()
    }

    func searchPlacesByText(text: String) -> AnyPublisher<[Place], Error> {
        let parameters: [String: Any] = [
            "query": text
        ]
        let target = Target(
            baseURL: "https://maps.googleapis.com",
            path: "/maps/api/place/textsearch/json",
            authorizationType: .queryParameter(key: "key", value: token),
            task: .queryParameters(parameters)
        )
        return networkClient.request(target)
            .receive(on: DispatchQueue.main)
            .map(\PlaceResponse.results)
            .eraseToAnyPublisher()
    }
}
