//
//  ContextInspectTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 15.01.22.
//

import XCTest
@testable import GoPortApi

class ContextInspectTest: GoPortApiBaseTest {
    
    func testContextInspectDecoding() throws {
        let context: ContextInspectResponse = try MockHelper.load(ContextInspectResponse.previewFilename)
        
        XCTAssertEqual(context.name, "default")
        XCTAssertEqual(context.stackOrchestrator, "swarm")
        XCTAssertEqual(context.description, "Central Server")
    }
    
    func testContextInspectAPISuccess() async throws {
        let context = try await ContextAPI.contextInspect(host: host, name: "", session: session)
        
        XCTAssertEqual(context.name, "default")
    }
    
}
