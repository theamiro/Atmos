//
//  PlaceResponse.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import Foundation

struct PlaceResponse: Decodable {
    let results: [Place]
}

struct Place: Decodable {
    let id: String
    let name: String
    let address: String
    let geometry: PlaceGeometry

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name
        case address = "formatted_address"
        case geometry
    }
}

struct PlaceGeometry: Decodable {
    var location: PlaceLocation
}

struct PlaceLocation: Decodable {
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
