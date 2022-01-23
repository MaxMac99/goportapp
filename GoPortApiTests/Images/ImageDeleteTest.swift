//
//  ImageDeleteTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageDeleteTest: GoPortApiBaseTest {

    func testImageDeleteAPISuccess() async throws {
        let response = try await ImageAPI.imageDelete(host: host, name: "", session: session)
        
        XCTAssertEqual(response.count, 4)
    }

}
