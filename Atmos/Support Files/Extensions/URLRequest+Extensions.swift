//
//  URLRequest+Extensions.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Foundation

extension URLRequest {
    func curlString() -> String {
        var body = "curl \""
        let lineBreak = "\n"
        let space = " "
        body += self.url?.absoluteString ?? ""
        body += "\""
        body += space
        body += self.httpMethod ?? ""
        body += lineBreak
        if let httpBody = self.httpBody {
            body += String(describing: String(data: httpBody, encoding: .utf8))
        }
        return body
    }

    mutating func configureParameters(using target: AnyTarget) {
        switch target.task {
        case .queryParameters(let parameters):
            var queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                var stringValue: String?
                switch value {
                case let string as String:
                    stringValue = string
                case let number as NSNumber:
                    stringValue = number.stringValue
                case let bool as Bool:
                    stringValue = bool ? "true" : "false"
                default:
                    break
                }
                queryItems.append(URLQueryItem(name: key, value: stringValue))
            }
            self.url?.append(queryItems: queryItems)
        case .plainRequest:
            break
        }
    }

    mutating func configureAuthorization(using target: AnyTarget) {
        guard let token = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            return
        }
        switch target.authorizationType {
        case .bearer:
            setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .queryParameter(let key):
            let apiKeyQueryItem = URLQueryItem(name: key, value: token)
            url?.append(queryItems: [apiKeyQueryItem])
        default: break
        }
    }
}
