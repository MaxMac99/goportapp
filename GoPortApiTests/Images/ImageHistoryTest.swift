//
//  ImageHistoryTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageHistoryTest: GoPortApiBaseTest {

    func testImageHistoryAPISuccess() async throws {
        let response = try await ImageAPI.imageHistory(host: host, name: "", context: "default", session: session)
        
        XCTAssertEqual(response.count, 4)
    }

}
