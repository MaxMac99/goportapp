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
        let response: SystemEventsResponse = try MockHelper.load(SystemEventsResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.actor!.id, "4cb1fa3862ac93bb9d82922622e2215f16faba7b4df9c5fe52717fbf28690996")
    }
    
    func testSystemVersionAPISuccess() async throws {
        let response = try await SystemAPI.systemEvents(host: host, session: session)
        
        var events = [SystemEventsResponse]()
        for try await event in response.stream {
            events.append(event)
        }
        
        XCTAssertEqual(events.count, 5)
    }

}
