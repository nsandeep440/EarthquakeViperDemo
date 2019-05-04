//
//  BaseRequest.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 03/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit
import BrightFutures
import SwiftyJSON

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

class ApiRequest: NSObject {
    
    static let shared = ApiRequest()
    
    func GET(_ urlString: String) -> Future<JSON, NSError> {
        guard let url = URL(string: urlString) else {
            let promise = Promise<JSON, NSError>()
            let err = NSError()
            promise.tryFailure(err)
            return promise.future
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        self.addRequestHeaders(request: &request)
        return self.makeRequest(request)
    }
    
    func addRequestHeaders(request: inout URLRequest) {
        var headers: [String: String] = [:]
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    func makeRequest(_ request: URLRequest) -> Future<JSON, NSError> {
        let promise = Promise<JSON, NSError>()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error as NSError? {
                promise.tryFailure(err)
            }
            
            if let response = response as? HTTPURLResponse, let data = data, 200...299 ~= response.statusCode {
                if let json = try? JSON(data: data, options: .allowFragments) {
                    promise.trySuccess(json)
                } else {
                    promise.trySuccess(JSON())
                }
            }
            
            if let response = response as? HTTPURLResponse, let data = data, 400...599 ~= response.statusCode {
                var errorMessage = "No error message provided"
                if let jsonError = try? JSON(data: data, options: .allowFragments) {
                    errorMessage = jsonError["error"].string ?? "No error message provided"
                    //Check for detail as well as 'error' server can send both
                    if errorMessage == "No error message provided" {
                        errorMessage = jsonError["detail"].string ?? "No error message provided"
                    }
                }
            }
        }
        task.resume()
        return promise.future
    }
}
