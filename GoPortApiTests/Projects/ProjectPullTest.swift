//
//  ProjectPullTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
@testable import GoPortApi

class ProjectPullTest: GoPortApiBaseTest {

    func testProjectStreamPullAPISuccess() async throws {
        let response = try await ProjectAPI.projectStreamPull(host: host, name: "", session: session)
        
        var logs = [String]()
        for try await log in response.stream {
            logs.append(log)
        }
        let fullResponse = logs.joined(separator: "")
        let originalResponse = String(data: try MockHelper.loadFile("ProjectPullResponse", withExtension: "txt"), encoding: .utf8)! + "\n"
        
        XCTAssertEqual(fullResponse, originalResponse)
    }
    
    func testProjectPullAPISuccess() async throws {
        let response = try await ProjectAPI.projectPull(host: host, name: "", session: session)
        
        let originalResponse = String(data: try MockHelper.loadFile("ProjectPullResponse", withExtension: "txt"), encoding: .utf8)!
        
        XCTAssertEqual(response, originalResponse)
    }

}
