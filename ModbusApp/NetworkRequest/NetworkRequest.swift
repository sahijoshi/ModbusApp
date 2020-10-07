//
//  NetworkRequest.swift
//  ModbusApp
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import UIKit

class NetworkRequest {
    
    enum ResponseResult {
        case success
        case failure(NetworkError)
    }
    
    /// This is a generic method for network request using URLSession.
    /// - Parameters:
    ///   - route: enum variable of type Router.
    ///   - session: instance of URLSession
    ///   - completion: This completion handler takes Result with data and error parameter return by URLSession.
    /// - Returns: Void
    
    static func request<T: Decodable>(_ route: Router, with session:URLSession, completion: @escaping (Result<T, NetworkError>) -> () ) {
        let request =  route.asURLRequest()
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse else {
                // invalid response
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            // check response status code
            let result = handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    // data is empty
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                do {
                    #if DEBUG
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    
                    dLog(response)
                    dLog(jsonData)
                    #endif
                                        
                    let requiredData = try JSONDecoder().decode(T.self, from: responseData)
                    completion(.success(requiredData))
                } catch {
                    dLog(error)
                    completion(.failure(NetworkError.notDecodable))
                }
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
        
        dataTask.resume()
    }
    
    fileprivate static func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseResult {
        switch response.statusCode {
        case 200...299: return .success
        case 501...599: return .failure(.invalidRequest)
        case -1009: return .failure(.noInternetConnection)
        default: return .failure(.failed)
        }
    }
}


