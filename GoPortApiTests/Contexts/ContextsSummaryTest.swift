//
//  ContextSummaryDecodingTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.12.21.
//

import XCTest
@testable import GoPortApi

class ContextSummaryTest: XCTestCase {

    func testContextSummaryDecoding() throws {
        let contexts: [ContextSummary] = try MockHelper.load(ContextSummary.previewFilename)
        
        XCTAssertEqual(contexts.count, 5)
    }

}
