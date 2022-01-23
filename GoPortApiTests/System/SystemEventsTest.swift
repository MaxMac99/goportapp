//
//  SystemEventsTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 18.01.22.
//

import XCTest
@testable import GoPortApi

class SystemEventsTest: GoPortApiBaseTest {
    
    func testSystemEventsResponseDecoding() throws {
        let response: [SystemEventsResponse] = try MockHelper.stream(SystemEventsResponse.previewFilename)
        
        XCTAssertEqual(response.first!["default"]!.actor!.id, "b470d659f8839a974a7cd835098c23302fafbc9e0cb00a6503fcb8a85b130190")
    }
    
    func testSystemVersionAPISuccess() async throws {
        let response = try await SystemAPI.systemEvents(host: host, session: session)
        
        var events = [SystemEventsResponse]()
        for try await event in response.stream {
            events.append(event)
        }
        
        XCTAssertEqual(events.count, 8)
    }

}
