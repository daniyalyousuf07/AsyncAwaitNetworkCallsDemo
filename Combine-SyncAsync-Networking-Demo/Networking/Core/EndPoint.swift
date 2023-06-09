//
//  EndPoint.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

protocol Endpoint {
    var queryItems: [URLQueryItem]? { get set }
    
    var scheme: String? { get }
    var host: String? { get }
    var port: Int? { get }
    
    func getURL(path: String) -> URL?
}

extension Endpoint {
    func getURL(path: String) -> URL? {
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
    var queryItems: [URLQueryItem]? = nil
    var scheme: String? = "https"
    var host: String? = "api.thecatapi.com"
    var port: Int? = nil
}
