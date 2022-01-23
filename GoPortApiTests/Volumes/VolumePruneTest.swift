//
//  VolumePruneTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class VolumePruneTest: GoPortApiBaseTest {

    func testVolumePruneAPISuccess() async throws {
        let response = try await VolumeAPI.volumePrune(host: host, session: session)
        
        XCTAssertEqual(response.first!.value.volumesDeleted?.count, 41)
    }

}
