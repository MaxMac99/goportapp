//
//  ContainerLogResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 24.01.22.
//

import Foundation
import SwiftUI

public typealias ContainerLogResponse = [ContainerLogResponseItem]

public struct ContainerLogResponseItem: Hashable, DataConvertible, DataArrayConvertible {
    public enum StreamType: Int, Decodable {
        case stdin = 0
        case stdout
        case stderr
        
        enum CodingKeys: String, CodingKey {
            case stdin, stdout, stderr
        }
    }
    
    public enum ContainerLogError: Error {
        case decodingError
    }
    
    public private(set) var streamType: StreamType
    public private(set) var log: NSAttributedString
    public private(set) var timestamp: Date? = nil
    
    public init(streamType: StreamType, log: NSAttributedString, timestamp: Date? = nil) {
        self.streamType = streamType
        self.log = log
        self.timestamp = timestamp
    }
    
    public init(streamType: StreamType, log: String, timestamp: Date? = nil, isAnsi: Bool = true) {
        self.streamType = streamType
        self.timestamp = timestamp
        if isAnsi {
            self.log = ContainerLogResponseItem.parseAnsiLogMessage(log)
        } else {
            self.log = NSAttributedString(string: log)
        }
    }
    
    public static func convert(_ data: Data) throws -> ContainerLogResponseItem {
        var readData = data
        guard let log = getNextLog(from: &readData) else {
            throw ContainerLogError.decodingError
        }
        return log
    }
    
    public static func convert(_ data: Data) -> [ContainerLogResponseItem] {
        var logs = [ContainerLogResponseItem]()
        var readData = data
        while let log = getNextLog(from: &readData) {
            logs.append(log)
        }
        return logs
    }
    
    private static func getNextLog(from readData: inout Data) -> ContainerLogResponseItem? {
        guard readData.count >= 8 else {
            return nil
        }
        let streamTypeInt = readData.first!
        let size = Int(readData.subdata(in: 4..<8).reversed().withUnsafeBytes({ $0.load(as: UInt32.self)}))
        if size+8 > readData.count {
            return nil
        }
        
        var logEntryString = String(decoding: readData.subdata(in: 8..<size+8), as: UTF8.self)
        readData = readData.subdata(in: size+8..<readData.count)
        
        var timestamp: Date? = nil
        if let spaceIndex = logEntryString.firstIndex(of: " ") {
            let timestampString = String(logEntryString[..<spaceIndex])
            let dateTimeFormatter = DateFormatter()
            dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"
            timestamp = dateTimeFormatter.date(from: timestampString)
            if timestamp != nil {
                let nextIndex = logEntryString.index(spaceIndex, offsetBy: 1)
                logEntryString = String(logEntryString[nextIndex...])
            }
        }
        
        if let streamType = StreamType(rawValue: Int(streamTypeInt)) {
            if logEntryString.last == "\n" {
                logEntryString = String(logEntryString.dropLast())
            }
            return ContainerLogResponseItem(streamType: streamType, log: logEntryString, timestamp: timestamp)
        }
        return nil
    }
    
    static func parseAnsiLogMessage(_ log: String) -> NSAttributedString {
        let components = log.components(separatedBy: "\u{1B}[")
        let output = NSMutableAttributedString()
        var isAnsi = false
        for component in components {
            if component == "" {
                isAnsi = true
                continue
            }
            var realString = component
            var options = [NSAttributedString.Key: Any]()
            if isAnsi, let nextM = realString.firstIndex(of: "m") {
                let ansiSequence = realString[..<nextM].split(separator: ";").map({ Int($0)! })
                realString = String(realString[nextM...].dropFirst())
                options = parseAnsiCodes(ansiSequence)
            }
            let attributedComponent = NSMutableAttributedString(string: realString, attributes: options)
            output.append(attributedComponent)
            isAnsi = true
        }
        return output
    }
    
    static func parseAnsiCodes(_ ansiCodes: [Int]) -> [NSAttributedString.Key:Any] {
        var bold = false
        var light = false
        var foregroundColor: Color? = nil
        var backgroundColor: Color? = nil
        var options = [NSAttributedString.Key: Any]()
        
        var i = 0
        while i < ansiCodes.count {
            let ansiCode = ansiCodes[i]
            switch ansiCode {
            case 1: bold = true
            case 2: light = true
            case 4: options[.underlineStyle] = 1
            case 5: options[.strikethroughStyle] = 1
            case 30..<38:
                var colorCode = ansiCode
                if i+1 < ansiCodes.count && ansiCodes[i+1] == 1 {
                    colorCode += 60
                    i += 1
                }
                foregroundColor = parse4BitColor(colorCode)
            case 40..<48:
                var colorCode = ansiCode
                if i+1 < ansiCodes.count && ansiCodes[i+1] == 1 {
                    colorCode += 60
                    i += 1
                }
                backgroundColor = parse4BitColor(colorCode)
            case 38:
                i += 1
                if i+1 < ansiCodes.count && ansiCodes[i] == 5 {
                    i += 1
                    foregroundColor = parse8BitColor(ansiCodes[i])
                } else if i+3 < ansiCodes.count && ansiCodes[i] == 2 {
                    foregroundColor = Color(hexRed: ansiCodes[i+1], green: ansiCodes[i+2], blue: ansiCodes[i+3])
                    i += 3
                }
            case 48:
                i += 1
                if i+1 < ansiCodes.count && ansiCodes[i] == 5 {
                    i += 1
                    backgroundColor = parse8BitColor(ansiCodes[i])
                } else if i+3 < ansiCodes.count && ansiCodes[i] == 2 {
                    backgroundColor = Color(hexRed: ansiCodes[i+1], green: ansiCodes[i+2], blue: ansiCodes[i+3])
                    i += 3
                }
            case 90..<98:
                foregroundColor = parse4BitColor(ansiCode)
            case 100..<108:
                backgroundColor = parse4BitColor(ansiCode)
            default:
                break
            }
            i += 1
        }
        options[.font] = UIFont.monospacedSystemFont(ofSize: 14, weight: bold ? .bold : light ? .light : .regular)
        if let foregroundColor = foregroundColor {
            options[.foregroundColor] = UIColor(foregroundColor)
        }
        if let backgroundColor = backgroundColor {
            options[.backgroundColor] = UIColor(backgroundColor)
        }
        return options
    }
    
    static func parse4BitColor(_ code: Int) -> Color? {
        switch code {
        case 30, 40:
            return Color(hexRed: 0, green: 0, blue: 0)
        case 31, 41:
            return Color(hexRed: 194, green: 54, blue: 33)
        case 32, 42:
            return Color(hexRed: 37, green: 188, blue: 36)
        case 33, 43:
            return Color(hexRed: 173, green: 173, blue: 39)
        case 34, 44:
            return Color(hexRed: 73, green: 46, blue: 225)
        case 35, 45:
            return Color(hexRed: 211, green: 56, blue: 211)
        case 36, 46:
            return Color(hexRed: 51, green: 187, blue: 200)
        case 37, 47:
            return Color(hexRed: 203, green: 204, blue: 205)
        case 90, 100:
            return Color(hexRed: 129, green: 131, blue: 131)
        case 91, 101:
            return Color(hexRed: 252, green: 57, blue: 31)
        case 92, 102:
            return Color(hexRed: 49, green: 231, blue: 34)
        case 93, 103:
            return Color(hexRed: 234, green: 236, blue: 35)
        case 94, 104:
            return Color(hexRed: 88, green: 51, blue: 255)
        case 95, 105:
            return Color(hexRed: 249, green: 53, blue: 248)
        case 96, 106:
            return Color(hexRed: 20, green: 240, blue: 240)
        case 97, 107:
            return Color(hexRed: 233, green: 235, blue: 235)
        default:
            return nil
        }
    }
    
    static func parse8BitColor(_ code: Int) -> Color? {
        if code < 8 {
            return parse4BitColor(code + 30)
        } else if code < 16 {
            return parse4BitColor(code + 90)
        } else if code < 232 {
            let base = code - 16
            let red = Double(base / 36)
            let green = Double(base / 6 % 6)
            let blue = Double(base % 6)
            return Color(red: red / 6, green: green / 6, blue: blue / 6)
        } else {
            return Color(white: Double(code - 232) / 23)
        }
    }
}

extension Color {
    init(hexRed: Int, green: Int, blue: Int) {
        self.init(red: Double(hexRed) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0)
    }
}

#if DEBUG
extension ContainerLogResponseItem: Previewable {
    public static var preview: ContainerLogResponseItem {
        let data = try! MockHelper.loadFile("ContainerLogsTimestamp", withExtension: "bin")
        return ContainerLogResponseItem.convert(data).first!
    }
    
    public var asData: Data {
        get throws {
            try asStreamData
        }
    }
}

extension ContainerLogResponseItem: StreamPreviewable {
    public static var previews: [ContainerLogResponseItem] {
        let data = try! MockHelper.loadFile("ContainerLogsTimestamp", withExtension: "bin")
        return ContainerLogResponseItem.convert(data)
    }
    
    public var asStreamData: Data {
        get throws {
            var data = Data()
            data.append(contentsOf: [UInt8(streamType.rawValue), 0, 0, 0])
            var response = log.string
            if let timestamp = timestamp {
                let dateTimeFormatter = DateFormatter()
                dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"
                let dateString = dateTimeFormatter.string(from: timestamp)
                response = dateString + " " + response
            }
            guard let string = response.data(using: .utf8) else {
                throw ContainerLogError.decodingError
            }
            let count = string.count + 1 // \n kommt noch hinzu
            let sizeArray = withUnsafeBytes(of: count.littleEndian, Array.init).reversed()[4...]
            data.append(contentsOf: sizeArray)
            data.append(contentsOf: string)
            return data
        }
    }
}
#endif
