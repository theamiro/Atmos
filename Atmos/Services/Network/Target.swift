//
//  Target.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation

struct Target: AnyTarget {
    var baseURL: String { "https://api.openweathermap.org" }
    var path: String
    var method: HTTPMethod
    var sampleData: Data
    var authorizationType: AuthorizationType
    var headers: [String: Any]?
    var parameters: Encodable?

    init(path: String,
         method: HTTPMethod = .get,
         sampleData: Data = Data(),
         authorizationType: AuthorizationType = .none,
         headers: [String: Any]? = nil,
         parameters: Encodable? = nil) {
        self.path = path
        self.method = method
        self.sampleData = sampleData
        self.authorizationType = authorizationType
        self.headers = headers
        self.parameters = parameters
    }
}
