//
//  GeoCodeResponse.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import Foundation

struct GeoCodeResponse: Decodable {
    let results: [GeoCodeAddress]
}

struct GeoCodeAddress: Decodable {
    let addressComponents: [Address]
    let formattedAddress: String

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
    }
}

struct Address: Decodable {
    var longName: String
    var shortName: String
    var types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}
