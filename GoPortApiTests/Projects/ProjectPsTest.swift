//
//  ProjectPsTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectPsTest: GoPortApiBaseTest {

    func testProjectPsAPISuccess() async throws {
        let response = try await ProjectAPI.projectPs(host: host, name: "", session: session)
        
        XCTAssertEqual(response.count, 1)
    }

}
