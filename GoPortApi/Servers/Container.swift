//
//  Container.swift
//  GoPortApi
//
//  Created by Max Vissing on 30.01.22.
//

import Foundation

public struct Container: Identifiable {
    public private(set) var id: String
    private let contextRef: Reference<GoPortContext>
    
    public var context: GoPortContext {
        contextRef.value
    }
    
    init(id: String, context: GoPortContext) {
        self.id = id
        self.contextRef = Reference(context)
    }
}

extension Container: Equatable {
    public static func == (lhs: Container, rhs: Container) -> Bool {
        lhs.id == rhs.id
    }
}

extension Container: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
