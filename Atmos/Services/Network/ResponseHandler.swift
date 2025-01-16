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
            print(String(describing: response))
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(_, let context):
                    print("Type Mismatch: ", context.codingPath, context.debugDescription)
                case .valueNotFound(_, let context):
                    print("Value not found: ", String(describing: context.underlyingError?.localizedDescription))
                case .keyNotFound(let codingKey, let context):
                    print("Key not Found for codingKey: \(codingKey.stringValue)",
                          String(describing: context.underlyingError?.localizedDescription))
                case .dataCorrupted(let context):
                    print("Data corrupted error: ", String(describing: context.underlyingError?.localizedDescription))
                @unknown default:
                    print("Unknown decoding error: ", error.localizedDescription)
                }
                return Fail(error: decodingError).eraseToAnyPublisher()
            } else {
                print(error.localizedDescription)
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
        }
    }
}
