//
//  SystemPingTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 30.12.21.
//

import XCTest
@testable import GoPortApi

class SystemPingTest: GoPortApiBaseTest {
    
    func testSystemPingResponseDecoding() throws {
        let response: SystemPingResponse = try MockHelper.load(SystemPingResponse.previewFilename)
        
        XCTAssertEqual(response.count, 5)
    }
    
    func testSystemPingResponseHeaderDecoding() throws {
        let response: SystemPingHeader = try SystemPingHeader(MockHelper.loadHeaders(SystemPingHeader.previewFilename))
        
        XCTAssertEqual(response.goportVersion, "v1")
    }
    
    func testSystemPingAPISuccess() async throws {
        let response = try await SystemAPI.systemPing(host: host, context: ["default"], session: session)
        
        XCTAssertEqual(response.goportVersion, "v1")
    }

}
