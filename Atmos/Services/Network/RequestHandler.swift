//
//  RequestHandler.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import Combine

protocol RequestHandlerDelegate: AnyObject {
    func execute(_ target: AnyTarget) -> AnyPublisher<Data, Error>
}

class RequestHandler: RequestHandlerDelegate {
    private var session: URLSession
    private var stubBehavior: StubBehavior

    init(session: URLSession = .shared, stubBehavior: StubBehavior = .never) {
        self.session = session
        self.stubBehavior = stubBehavior
    }

    func execute(_ target: any AnyTarget) -> AnyPublisher<Data, any Error> {
        guard let url = URL(string: target.baseURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url.appendingPathComponent(target.path))
        request.httpMethod = target.method.rawValue
        request.configureParameters(using: target)
        request.configureAuthorization(using: target)

        print(request.curlString())

        guard stubBehavior == .never else {
            return Just(target.sampleData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return session
            .dataTaskPublisher(for: request)
            .map { (data: Data, response: URLResponse) in
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return data
                }
                guard (200...300).contains(response.statusCode) else {
                    print("Invalid status code: \(response.statusCode)")
                    return data
                }
                print(String(describing: String(data: data, encoding: .utf8)))
                return data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
