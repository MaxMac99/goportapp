//
//  Loadable.swift
//  GoPort
//
//  Created by Max Vissing on 15.01.22.
//

import Foundation

enum Loadable<Wrapped> {
    case notStarted
    case loading
    case error(Error)
    case loaded(Wrapped)
    
    init() {
        self = .notStarted
    }
    
    init(_ loadableResult: () throws -> Wrapped) {
        do {
            self = .loaded(try loadableResult())
        } catch {
            self = .error(error)
        }
    }
    
    init(_ loadableResult: () async throws -> Wrapped) async {
        do {
            self = .loaded(try await loadableResult())
        } catch (let wrappedError) {
            print("Loadable<\(Wrapped.self)>.error: \(wrappedError)")
            self = .error(wrappedError)
        }
    }
    
    init(_ content: Wrapped) {
        self = .loaded(content)
    }
    
    var content: Wrapped? {
        switch self {
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }
    var wrappedError: Error? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}
