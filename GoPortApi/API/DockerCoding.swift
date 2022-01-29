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
            var time = Double(dateInt)
            if dateInt > 100000000000 {
                time /= 1000
            }
            return Date(timeIntervalSince1970: time)
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Not supported date format")
    })
    return decoder
}()

internal let dockerEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .custom({ date, encoder in
        var container = encoder.singleValueContainer()
        var timestamp = date.timeIntervalSince1970
        if floor(timestamp) != timestamp { // has fraction
            timestamp *= 1000
        }
        try container.encode(floor(timestamp))
    })
    return encoder
}()
