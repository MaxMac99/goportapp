//
//  ContainerLogsTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 24.01.22.
//

import XCTest
@testable import GoPortApi

class ContainerLogsTest: GoPortApiBaseTest {
    
    func testContainerLogsAPISuccess() async throws {
        let response = try await ContainerAPI.containerLogs(host: host, id: "", session: session)
        
        XCTAssertEqual(response.count, 13)
    }
    
    func testContainerStreamLogsAPISuccess() async throws {
        let response = try await ContainerAPI.containerStreamLogs(host: host, id: "", session: session)
        
        var logs = [ContainerLogResponseItem]()
        for try await log in response.stream {
            logs.append(log)
        }
        
        XCTAssertEqual(logs.count, 13)
    }

    func testContainerLogsDecoding() throws {
        let data = try MockHelper.loadFile("ContainerLogs", withExtension: "bin")
        let logs: [ContainerLogResponseItem] = ContainerLogResponseItem.convert(data)
        
        XCTAssertEqual(logs.count, 13)
    }
    
    func testContainerLogsTimestampDecoding() throws {
        let data = try MockHelper.loadFile("ContainerLogsTimestamp", withExtension: "bin")
        let logs: [ContainerLogResponseItem] = ContainerLogResponseItem.convert(data)
        
        XCTAssertEqual(logs.count, 13)
    }

}
