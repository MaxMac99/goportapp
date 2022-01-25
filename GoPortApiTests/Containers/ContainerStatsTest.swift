//
//  ContainerStatsTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerStatsTest: GoPortApiBaseTest {

    func testContainerStatsAPISuccess() async throws {
        let response = try await ContainerAPI.containerStats(host: host, id: "", session: session)
        
        XCTAssertEqual(response.id, "33d75a667bfeda3242abea4465614b48f7b67cbdd59f14684e3ce5d0c7aca18e")
    }
    
    func testContainerStatsStreamAPISuccess() async throws {
        let response = try await ContainerAPI.containerStreamStats(host: host, id: "", session: session)
        
        var stats = [ContainerStatsResponse]()
        for try await stat in response.stream {
            stats.append(stat)
        }
        
        XCTAssertEqual(stats.count, 6)
    }

}
