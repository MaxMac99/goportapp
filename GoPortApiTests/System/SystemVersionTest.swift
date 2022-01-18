//
//  SystemVersionTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 16.01.22.
//

import XCTest
@testable import GoPortApi

class SystemVersionTest: GoPortApiBaseTest {
    
    func testSystemVersionResponseDecoding() throws {
        let response: SystemVersionResponse = try MockHelper.load(SystemVersionResponse.previewFilename)
        
        XCTAssertEqual(response.version, "20.10.11")
    }
    
    func testSystemVersionAPISuccess() async throws {
        let version = try await SystemAPI.systemVersion(host: host, context: "", session: session)
        
        XCTAssertEqual(version.version, "20.10.11")
    }

}
