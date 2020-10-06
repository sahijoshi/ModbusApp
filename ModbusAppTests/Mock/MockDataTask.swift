//
//  MockDataTask.swift
//  ModbusAppTests
//
//  Created by skj on 6.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation
@testable import ModbusApp

class MockDataTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let modbusError: Error?

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
      self.data = data
      self.urlResponse = urlResponse
      self.modbusError = error
    }
    
    override func resume() {
      DispatchQueue.main.async {
        self.completionHandler?(self.data, self.urlResponse, self.modbusError)
      }
    }
}
