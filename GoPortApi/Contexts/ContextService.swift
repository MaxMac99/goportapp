//
//  ContextService.swift
//  GoPortApi
//
//  Created by Max Vissing on 29.12.21.
//

import Foundation

@MainActor
public class ContextService: ObservableObject {
    @Published public private(set) var contexts: [ContextSummary] = []
    
    public init() {
    }
    
    public func load(from host: URL) async throws {
        contexts = try await ContextAPI.contextList(host: host)
    }
}

#if DEBUG
public extension ContextService {
    static var preview: ContextService {
        let service = ContextService()
        service.contexts = ContextSummary.preview
        return service
    }
}
#endif
