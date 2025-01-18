//
//  URLRequest+Extensions.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Foundation

extension URLRequest {
    func curlString() -> String {
        var body = ""
        let lineBreak = "\n"
        let space = " "
        body += self.url?.absoluteString ?? ""
        body += space
        body += self.httpMethod ?? ""
        body += lineBreak
        if let httpBody = self.httpBody {
            body += String(describing: String(data: httpBody, encoding: .utf8))
        }
        return body
    }
}
