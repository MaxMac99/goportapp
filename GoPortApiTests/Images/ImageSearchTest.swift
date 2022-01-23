//
//  ImageSearchTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageSearchTest: GoPortApiBaseTest {

    func testImageSearchAPISuccess() async throws {
        let response = try await ImageAPI.imageSearch(host: host, term: "hello-world", session: session)
        
        XCTAssertEqual(response.count, 10)
    }

}
