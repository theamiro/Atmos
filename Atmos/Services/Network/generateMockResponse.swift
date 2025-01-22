//
//  generateMockResponse.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Foundation

func generateMockResponse(_ resource: String, `extension`: String = "json") -> Data {
    var data: Data
    if let url = Bundle.main.url(forResource: resource, withExtension: `extension`) {
        do {
            data = try Data(contentsOf: url, options: .mappedIfSafe)
        } catch {
            data = Data()
            log.error("Unable to retrieve contents of url: \(url.absoluteString)")
        }
    } else {
        log.error("Invalid URL")
        data = Data()
    }
    return data
}
