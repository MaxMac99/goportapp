//
//  ProjectEventsTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectEventsTest: GoPortApiBaseTest {

    func testProjectEventsAPISuccess() async throws {
        let response = try await ProjectAPI.projectEvents(host: host, name: "", session: session)
        
        var logs = [ProjectEventResponseItem]()
        for try await log in response.stream {
            logs.append(log)
        }
        
        XCTAssertEqual(logs.count, 5)
    }

}
