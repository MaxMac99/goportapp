//
//  ErrorMessage.swift
//  GoPortApi
//
//  Created by Max Vissing on 27.01.22.
//

import Foundation

public struct ErrorMessage: Codable, Hashable {
    public var message: String
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case message = "message"
    }
}
