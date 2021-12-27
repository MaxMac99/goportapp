//
//  JsonDecodingHelper.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import Foundation
import Combine

extension Optional where Wrapped == Data {
    func jsonDecoded<T: Decodable>(_ type: T.Type) -> T? {
        if let data = self {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}

extension NSObject.KeyValueObservingPublisher where Subject == UserDefaults, Value == Data? {
    func jsonDecode<T: Decodable>(type: T.Type) -> AnyPublisher<T?, Never> {
        return flatMap { (input) -> AnyPublisher<T?, Never> in
            guard let data = input else {
                return Just(nil)
                    .eraseToAnyPublisher()
            }
            return Just(data)
                .decode(type: T.self, decoder: JSONDecoder())
                .map { (server) -> T? in
                    return server
                }
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
