# ModbusApp

This is an iOS-based mobile application developed for displaying Modbus live feed data in mobile app. The app gets data from Node.js in JSON format backend as described [here](https://github.com/sahijoshi/ModbusBackend). 

# Preview

# Technology
- Programming Language: Swift 5
- IDE: XCode 11.6
- Travis CI for unit test and continuous integration
- Architecturer Pattern: MVVM

# Requirement
- iOS 13.6 and above

# Installation
- Download from the repository.
- Open .xcworkspace file inside project folder with XCode.

# Architecture

# Implementation
- The Modbus data is received as JSON format.
- API: https://modbus-prod.herokuapp.com/modbus
- The Network layer has been implemented which gets data from server. All network related code including network error handling are inside Network folder.

#### Code
``` bash
// WebServices Class

    /// This method get Modbus data from the server.
    /// - Parameter completion: The completion handler takes Modbus model class parameter
    /// - Returns: void
    
    func getModbusData(completion: @escaping (Result<Modbus, NetworkError>) -> ()) {
        let router = Router.getModbusData
        
        NetworkRequest.request(router, with: session) { (result: Result<Modbus, NetworkError>) in
            completion(result)
        }
    }
 
 // Network Request Class
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
```

- MVVM architctural patter has been followed, which has been clearly separated with name and folder in XCode project.
- Modbus class is a Model, ModbusViewController is View, and ModbusViewModel is ViewModel which is responsible for all business logic and interaction between view and model.
- Data binding has been achieved with Boxing using property observers.

# Testing
- Unit test has been implemented with XCTest.
- Travis CI has been integrated on GitHub repo which takes care of Continuos Integration.

#### GitHub

#### Travis CI

# Author
Sahi Joshi, sahik.joshi@gmail.com



