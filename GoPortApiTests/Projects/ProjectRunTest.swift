//
//  ProjectRunTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectRunTest: GoPortApiBaseTest {

    func testProjectStreamRunAPISuccess() async throws {
        let response = try await ProjectAPI.projectStreamRun(host: host, name: "", service: "", body: ProjectRunBody.preview)
        
        var logs = [ProjectRunStreamResponse]()
        for try await log in response.stream {
            logs.append(log)
        }
        
        XCTAssertEqual(logs.count, 25)
    }
    
    func testProjectRunAPISuccess() async throws {
        let response = try await ProjectAPI.projectRun(host: host, name: "", service: "", body: ProjectRunBody.preview)
        
        XCTAssertEqual(response.containerId, "6fa1b72eceea596a46cd6b0031b613751f97fb2fe85c1dfb28f30b70622cc4e4")
    }

}
