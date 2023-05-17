//
//  EndPoint.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

protocol Endpoint {
    
    var path: String { get set }
    var queryItems: [URLQueryItem]? { get set }
    
    var scheme: String? { get }
    var host: String? { get }
    var port: Int? { get }
    
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        components.port = port
        
        return components.url
    }
}


struct DefaultEndpoint: Endpoint {
    var path: String
    var queryItems: [URLQueryItem]? = nil
    var scheme: String? = "https"
    var host: String? = "api.thecatapi.com"
    var port: Int? = nil
    
    init(path: String) {
        self.path = path
    }
}

extension DefaultEndpoint: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        path = value
    }
}
