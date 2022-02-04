//
//  GoPortImage.swift
//  GoPortApi
//
//  Created by Max Vissing on 31.01.22.
//

import Foundation

public struct GoPortImage: Identifiable {
    public private(set) var id: String
    private let contextRef: Reference<GoPortContext>
    
    public var context: GoPortContext {
        contextRef.value
    }
    
    public init(id: String, context: GoPortContext) {
        self.id = id
        self.contextRef = Reference(context)
    }
}

extension GoPortImage: Equatable {
    public static func == (lhs: GoPortImage, rhs: GoPortImage) -> Bool {
        lhs.id == rhs.id
    }
}

extension GoPortImage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#if DEBUG
extension GoPortImage {
    public static let preview: GoPortImage = {
        GoPortImage(id: "sha256:0ed6cc16db71fe88a719ffa7c0dd4f255b3257d729c11b336e8a3063f5637444", context: GoPortContext.preview.first!)
    }()
}
#endif
