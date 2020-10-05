//
//  NetworkRequest.swift
//  ModbusApp
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation

struct WebServices {
    
    /// This method get Modbus data from the server.
    /// - Parameter completion: The completion handler takes Modbus model class parameter
    /// - Returns: void
    
    static func getModbusData(completion: @escaping ([Modbus]?) -> ()) {
        let router = Router.getModbusData
        
        NetworkRequest.request(router){ (result: Result<ModbusBase, Error>) in
            switch result {
            case .success(let modusBus):
                completion(modusBus.modbus)
            case .failure:
                completion(nil)
            }
        }
    }
}
