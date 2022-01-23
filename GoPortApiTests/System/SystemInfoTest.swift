//
//  SystemInfoTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
@testable import GoPortApi

class SystemInfoTest: GoPortApiBaseTest {
    
    func testSystemInfoResponseDecoding() throws {
        let response: SystemInfoResponse = try MockHelper.load(SystemInfoResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.id, "HARP:XNQX:UFW5:QMYN:S2CA:T6JS:DEM7:DSPB:KQON:PZLG:Y2YU:AJFY")
    }

    func testSystemInfoAPISuccess() async throws {
        let response = try await SystemAPI.systemInfo(host: host, context: ["default"], session: session)
        
        XCTAssertEqual(response["default"]!.id, "HARP:XNQX:UFW5:QMYN:S2CA:T6JS:DEM7:DSPB:KQON:PZLG:Y2YU:AJFY")
    }

}
