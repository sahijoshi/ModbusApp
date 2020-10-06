//
//  MockURLSession.swift
//  ModbusAppTests
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation
@testable import ModbusApp

class MockURLSession: URLSession {
    var cachedURL: URL?
    private let mockDataTask: MockDataTask
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        mockDataTask = MockDataTask(data: data, urlResponse: urlResponse, error:error)
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedURL = request.url
        mockDataTask.completionHandler = completionHandler
        return mockDataTask
    }
}
