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

    var token: String = {
        return Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    }()

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

        print(String(describing: request.url?.absoluteString))

        switch target.authorizationType {
        case .bearer:
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        default: break
        }

        guard stubBehavior == .never else {
            return Just(target.sampleData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return session
            .dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
