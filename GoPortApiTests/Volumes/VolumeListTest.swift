//
//  VolumeListTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class VolumeListTest: GoPortApiBaseTest {

    func testVolumeListAPISuccess() async throws {
        let response = try await VolumeAPI.volumeList(host: host, session: session)
        
        XCTAssertEqual(response.first?.value.volumes.count, 42)
    }

}
