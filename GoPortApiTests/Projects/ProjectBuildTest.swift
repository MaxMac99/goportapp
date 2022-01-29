//
//  ProjectBuildTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 28.01.22.
//

import XCTest
@testable import GoPortApi

class ProjectBuildTest: GoPortApiBaseTest {

    func testProjectStreamBuildAPISuccess() async throws {
        let response = try await ProjectAPI.projectStreamBuild(host: host, name: "", session: session)
        
        var logs = [String]()
        for try await log in response.stream {
            logs.append(log)
        }
        let fullResponse = logs.joined(separator: "")
        let originalResponse = String(data: try MockHelper.loadFile("ProjectBuildResponse", withExtension: "txt"), encoding: .utf8)! + "\n"
        
        XCTAssertEqual(fullResponse, originalResponse)
    }

}
