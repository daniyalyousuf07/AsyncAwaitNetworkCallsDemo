//
//  GetService.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation


extension NetworkService {
    func get<T>() async throws -> Result<T, NetworkServiceError> where T : Decodable {
        var request = urlRequest.makeURLRequest()
        request.httpMethod = "GET"
        
        let  (data, response) = try await session.loadData(from: request)
        
        ///Handle errors as per situation
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return .failure(NetworkServiceError.serverError)
        }
        
        guard data.isEmpty == false else {
            return .failure(NetworkServiceError.unexpectedResponse)
        }
        
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(NetworkServiceError.decodingError)
        }
        
        return .success(decoded)
    }
}
