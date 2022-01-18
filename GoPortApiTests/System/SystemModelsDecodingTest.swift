//
//  SystemModelsDecodingTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 30.12.21.
//

import XCTest
@testable import GoPortApi

class SystemModelsDecodingTest: XCTestCase {
    
    func testSystemInfoResponseDecoding() throws {
        let response: SystemInfoResponse = try MockHelper.load(SystemInfoResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.id, "HARP:XNQX:UFW5:QMYN:S2CA:T6JS:DEM7:DSPB:KQON:PZLG:Y2YU:AJFY")
    }
    
    func testSystemPingResponseDecoding() throws {
        let response: SystemPingResponse = try MockHelper.load(SystemPingResponse.previewFilename)
        
        XCTAssertEqual(response.count, 5)
    }
    
    func testSystemPingResponseHeaderDecoding() throws {
        let response: SystemPingHeader = try SystemPingHeader(MockHelper.loadHeaders(SystemPingHeader.previewFilename))
        
        XCTAssertEqual(response.goportVersion, "v1")
    }

}
