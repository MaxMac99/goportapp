//
//  DockerCoding.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

fileprivate struct LowercasedCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int? {
        return nil
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}

internal let dockerDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
//    decoder.keyDecodingStrategy = .custom({ keys in
//        let lastKey = keys.last!
//        if lastKey.intValue != nil {
//            return lastKey
//        }
//        
//        let firstLetter = lastKey.stringValue.prefix(1).lowercased()
//        let modifiedKey = firstLetter + lastKey.stringValue.dropFirst()
//        
//        return LowercasedCodingKey(stringValue: modifiedKey)!
//    })
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        if let dateStr = try? container.decode(String.self) {
            let isoFormatter = ISO8601DateFormatter()
            if let date = isoFormatter.date(from: dateStr) {
                return date
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S'Z'"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateStr) {
                return date
            }
        } else if let dateInt = try? container.decode(UInt64.self) {
            return Date(timeIntervalSince1970: Double(dateInt))
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Not supported date format")
    })
    return decoder
}()

internal let dockerEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .custom({ keys in
        let lastKey = keys.last!
        if lastKey.intValue != nil {
            return lastKey
        }
        
        let firstLetter = lastKey.stringValue.prefix(1).uppercased()
        let modifiedKey = firstLetter + lastKey.stringValue.dropFirst()
        
        return LowercasedCodingKey(stringValue: modifiedKey)!
    })
    encoder.dateEncodingStrategy = .custom({ date, encoder in
        var container = encoder.singleValueContainer()
        try container.encode(date.timeIntervalSince1970)
    })
    return encoder
}()
