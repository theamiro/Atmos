//
//  NetworkClient.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import Combine

protocol NetworkClientDelegate: AnyObject {
    func request<Response>(_ target: AnyTarget) -> AnyPublisher<Response, Error> where Response: Decodable
}

class NetworkClient: NetworkClientDelegate {
    private var requestHandler: RequestHandlerDelegate
    private var responseHandler: ResponseHandlerDelegate
    private var cancellable = Set<AnyCancellable>()

    init(session: URLSession = .shared, stubBehavior: StubBehavior = .never) {
        self.requestHandler = RequestHandler(session: session, stubBehavior: stubBehavior)
        self.responseHandler = ResponseHandler()
    }

    func request<Response>(_ target: any AnyTarget) -> AnyPublisher<Response, any Error> where Response: Decodable {
        requestHandler.execute(target)
            .flatMap { [weak self] data -> AnyPublisher<Response, Error> in
                guard let self else {
                    fatalError("self is not available")
                }
                return self.responseHandler.decode(data: data, type: Response.self)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
