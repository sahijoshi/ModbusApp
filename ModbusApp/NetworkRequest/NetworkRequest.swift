//
//  NetworkRequest.swift
//  ModbusApp
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import UIKit

struct NetworkRequest {
    
    /// This is a generic method for network request using URLSession.
    /// - Parameters:
    ///   - route: enum variable of type Router.
    ///   - completion: This completion handler takes Result with data and error parameter return by URLSession.
    /// - Returns: void
    
    static func request<T: Decodable>(_ route: Router, completion: @escaping (Result<T, Error>) -> () ) {
        let request =  route.asURLRequest()
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let pointofInterest = try JSONDecoder().decode(T.self, from: data)
                completion(.success(pointofInterest))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
