//
//  Target.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation

struct Target: AnyTarget {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var sampleData: Data
    var authorizationType: AuthorizationType
    var headers: [String: Any]?
    var task: NetworkTask

    init(baseURL: String = "https://api.openweathermap.org",
         path: String,
         method: HTTPMethod = .get,
         sampleData: Data = Data(),
         authorizationType: AuthorizationType = .queryParameter(key: "appid"),
         headers: [String: Any]? = nil,
         task: NetworkTask = .plainRequest) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.sampleData = sampleData
        self.authorizationType = authorizationType
        self.headers = headers
        self.task = task
    }
}
