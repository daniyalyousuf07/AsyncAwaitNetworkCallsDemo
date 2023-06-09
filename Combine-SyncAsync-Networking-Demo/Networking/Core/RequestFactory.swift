//
//  RequestFactory.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

// MARK: - ServiceRequest
protocol RequestFactory {
    func makeURLRequest(path: String) -> URLRequest
    var defaultHeaders: [String: String] { get }
    var endpoint: Endpoint { get set }
}

extension RequestFactory {
    var defaultHeaders: [String: String] {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}

// MARK: - Default URL request factory
struct DefaultURLRequestFactory: RequestFactory {
    var endpoint: Endpoint
    private let keychain: AppKeychain
    
    init(endpoint: Endpoint,
         keychain: AppKeychain = SampleAppKeychain.shared) {
        self.endpoint = endpoint
        self.keychain = keychain
    }
    
    func makeURLRequest(path: String) -> URLRequest {
        guard let url = endpoint.getURL(path: path) else {
            fatalError("Unable to make url request")
        }
        
        var headers = defaultHeaders
        
        if let token = keychain.token {
            headers["Authorization"]  = "Bearer" + token
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
                
        return urlRequest
    }
}
