//
//  ProjectUpTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectUpTest: GoPortApiBaseTest {
    
    func testProjectStreamUpAPISuccess() async throws {
        let response = try await ProjectAPI.projectUp(host: host, name: "", session: session)
        
        var logs = [ProjectLogItem]()
        for try await log in response.stream {
            logs.append(log)
        }
        
        XCTAssertEqual(logs.count, 33)
    }

}
