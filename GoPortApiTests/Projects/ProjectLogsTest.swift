//
//  ProjectLogsTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectLogsTest: GoPortApiBaseTest {

    func testProjectStreamLogsAPISuccess() async throws {
        let response = try await ProjectAPI.projectStreamLogs(host: host, name: "", session: session)
        
        var logs = [ProjectLogItem]()
        for try await log in response.stream {
            logs.append(log)
        }
        
        XCTAssertEqual(logs.count, 33)
    }
    
    func testProjectLogsAPISuccess() async throws {
        let response = try await ProjectAPI.projectLogs(host: host, name: "", session: session)
        
        XCTAssertEqual(response.count, 7)
    }

}
