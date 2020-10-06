//
//  NetworkRequest.swift
//  ModbusApp
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation

class WebServices {
    var session = URLSession.shared
    
    /// This method get Modbus data from the server.
    /// - Parameter completion: The completion handler takes Modbus model class parameter
    /// - Returns: void
    
    func getModbusData(completion: @escaping (Result<ModbusBase, NetworkError>) -> ()) {
        let router = Router.getModbusData
        
        NetworkRequest.request(router, with: session) { (result: Result<ModbusBase, NetworkError>) in
            completion(result)
        }
    }
}
