//
//  ProjectListTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectListTest: GoPortApiBaseTest {

    func testProjectListAPISuccess() async throws {
        let response = try await ProjectAPI.projectList(host: host, session: session)
        
        XCTAssertEqual(response.first?.value.count, 2)
    }

}
