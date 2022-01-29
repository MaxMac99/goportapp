//
//  ProjectInspectTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectInspectTest: GoPortApiBaseTest {
    
    func testProjectInspectAPISuccess() async throws {
        let response = try await ProjectAPI.projectInspect(host: host, name: "", session: session)
        
        XCTAssertEqual(response.services?.first?.key, "test")
    }
    
}
