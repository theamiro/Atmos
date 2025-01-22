//
//  Publisher+Extensions.swift
//  Atmos
//
//  Created by Michael Amiro on 22/01/2025.
//

import Combine

extension Publisher {
    func handleOutput(completion: @escaping (Output) -> Void) -> AnyCancellable {
        self.sink { completed in
            switch completed {
            case .finished: break
            case .failure(let error):
                log.error("\(error.localizedDescription)")
            }
        } receiveValue: { value in
            completion(value)
        }
    }

    func toVoid() -> AnyCancellable {
        self.sink { completed in
            switch completed {
            case .finished: break
            case .failure(let error):
                log.error("\(error.localizedDescription)")
            }
        } receiveValue: { _ in }
    }
}
