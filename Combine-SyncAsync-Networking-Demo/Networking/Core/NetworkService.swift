//
//  NetworkService.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

// MARK: - NetworkService
protocol NetworkService {
    var session: Session { get set }
    var urlRequest: RequestFactory { get set }
    
    func get<T: Decodable>(path: String) async throws -> Result<T, NetworkServiceError>
}


// MARK: - Basic implementation
struct DefaultNetworkService: NetworkService {    
    var session: Session
    var urlRequest: RequestFactory
    private var appKeychain: AppKeychain
    
    init(session: Session = URLSession.shared,
         urlRequest: RequestFactory,
         appKeychain: AppKeychain = SampleAppKeychain.shared) {
        self.session = session
        self.urlRequest = urlRequest
        self.appKeychain = appKeychain
    }
}
