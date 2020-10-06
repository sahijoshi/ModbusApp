//
//  Router.swift
//  ModbusApp
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

protocol EndPointType {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

protocol URLConverter {
    func asURLRequest() throws -> URLRequest
}

enum Router: EndPointType, URLConverter {
    case getModbusData
    
    var baseURL: String {
        return Constants.URL.baseUrl
    }
    
    var method: HTTPMethod {
        switch self {
        case .getModbusData: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getModbusData:
            return "/modbus"
        }
    }
    
    func asURLRequest() -> URLRequest {
        let baseUrl = URL(string: baseURL)
        let url = URL(string: (baseUrl?.appendingPathComponent(path).absoluteString.removingPercentEncoding)!)
        var urlRequest = URLRequest(url: url!, timeoutInterval: TimeInterval(10 * 1000))
                
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        NetworkLogger.log(request: urlRequest)
        return urlRequest
    }
    
}
