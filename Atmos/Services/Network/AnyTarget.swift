//
//  AnyTarget.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation

protocol AnyTarget {
    var baseURL: String { get }
    var path: String { get set }
    var headers: [String: Any]? { get set }
    var method: HTTPMethod { get set }
    var authorizationType: AuthorizationType { get set }
    var sampleData: Data { get set }
    var task: NetworkTask { get set }
}

extension AnyTarget {
    var headers: [String: Any]? { nil }
    var authorizationType: AuthorizationType { .none }
    var task: NetworkTask { .plainRequest }
}

enum NetworkTask {
    case queryParameters(Dictionary<String, Any>)
    case plainRequest
}
