//
//  ProjectTopTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectTopTest: GoPortApiBaseTest {

    func testProjectTopAPISuccess() async throws {
        let response = try await ProjectAPI.projectTop(host: host, name: "", session: session)
        
        XCTAssertEqual(response.first?.id, "62fdb306e33e1fc56859c766c7f26143051796686499bc8920c29d8a80792ffd")
    }

}
