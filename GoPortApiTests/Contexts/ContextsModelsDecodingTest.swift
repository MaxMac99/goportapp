//
//  ContextSummaryDecodingTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.12.21.
//

import XCTest
@testable import GoPortApi

class ContextSummaryDecodingTest: XCTestCase {

    func testContextSummaryDecoding() throws {
        let contexts: [ContextSummary] = try MockHelper.load(ContextSummary.previewFile)
        
        XCTAssertEqual(contexts.count, 5)
    }
    
    func testContextInspectDecoding() throws {
        let context: ContextInspectResponse = try MockHelper.load(ContextInspectResponse.previewFile)
        
        XCTAssertEqual(context.name, "default")
        XCTAssertEqual(context.stackOrchestrator, "swarm")
        XCTAssertEqual(context.description, "Central Server")
    }

}
