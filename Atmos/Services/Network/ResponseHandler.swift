//
//  ResponseHandler.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import Combine

protocol ResponseHandlerDelegate: AnyObject {
    func decode<T>(data: Data, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable
}

class ResponseHandler: ResponseHandlerDelegate {
    func decode<T>(data: Data, type: T.Type) -> AnyPublisher<T, any Error> where T: Decodable {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(_, let context):
                    log.error("Type Mismatch", metadata: [
                        "context": "\(context.codingPath)",
                        "debugDescription": "\(context.debugDescription)"
                    ])
                case .valueNotFound(_, let context):
                    log.error("Value not found", metadata: [
                        "underlyingError": "\(String(describing: context.underlyingError?.localizedDescription))"
                    ])
                case .keyNotFound(let codingKey, let context):
                    log.error("Key not Found for codingKey", metadata: [
                        "codingKey": "\(codingKey.stringValue)",
                        "underlyingError": "\(String(describing: context.underlyingError?.localizedDescription))"
                    ])
                case .dataCorrupted(let context):
                    log.error("Data corrupted error", metadata: [
                        "underlyingError": "\(String(describing: context.underlyingError?.localizedDescription))"
                    ])
                @unknown default:
                    log.error("Unknown decoding error", metadata: [
                        "underlyingError": "\(error.localizedDescription)"
                    ])
                }
                return Fail(error: decodingError).eraseToAnyPublisher()
            } else {
            log.error("\(error.localizedDescription)")
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
        }
    }
}
