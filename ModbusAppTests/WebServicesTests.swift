//
//  WebServicesTests.swift
//  ModbusAppTests
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import XCTest
@testable import ModbusApp

class WebServicesTests: XCTestCase {

    override func setUpWithError() throws {

    }
    
    override func tearDownWithError() throws {
        
    }
    
    // MARK: Test
    
    // test url host and url path is valid for getModbusData
    
    func testGetModbusDataURLAndPath() {
        let mockURLSession = MockURLSession()
        let service = WebServices()
        service.session = mockURLSession
        
        service.getModbusData { (result) in
            // process result
        }
        
        XCTAssertEqual(mockURLSession.cachedURL?.host, "modbus-app.herokuapp.com", "Invalid Host")
        XCTAssertEqual(mockURLSession.cachedURL?.path, "/modbus", "Invalid path")
    }
}
