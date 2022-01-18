//
//  SystemDataUsageTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 17.01.22.
//

import XCTest
@testable import GoPortApi

class SystemDataUsageTest: GoPortApiBaseTest {
    
    func testSystemDataUsageResponseDecoding() throws {
        let response: SystemDataUsageResponse = try MockHelper.load(SystemDataUsageResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.layersSize, 11110455288)
    }
    
    func testSystemDataUsageAPISuccess() async throws {
        let response = try await SystemAPI.systemDataUsage(host: host, context: [], session: session)
        
        XCTAssertEqual(response["default"]!.layersSize, 11110455288)
    }
    
}
