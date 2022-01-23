//
//  ImageCreateTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageCreateTest: GoPortApiBaseTest {

    func testImageCreateAPISuccess() async throws {
        let response = try await ImageAPI.imageCreate(host: host, session: session)
        
        var responses = [ProgressResponse]()
        for try await item in response.stream {
            responses.append(item)
        }
        
        XCTAssertEqual(responses.count, 11)
    }

}
