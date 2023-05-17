//
//  Session.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

// MARK: - ServiceError
enum NetworkServiceError: Error {
    case invalidURL
    case decodingError
    case genericError(String)
    case invalidResponseCode(Int)
    case serverError
    case unexpectedResponse
    
    var errorMessageString: String {
        switch self {
        case .unexpectedResponse:
            return "Unexpected Response"
        case .serverError:
            return "Server error. Cannot process the request"
        case .invalidURL:
            return "Invalid URL encountered. Can't proceed with the request"
        case .decodingError:
            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
        case .genericError(let message):
            return message
        case .invalidResponseCode(let responseCode):
            return "Invalid response code encountered from the server. Expected 200, received \(responseCode)"
        }
    }
}

// MARK: -  Session
protocol Session {
    func loadData(from urlRequest: URLRequest) async throws  -> (Data, URLResponse)
}

extension URLSession: Session {
    func loadData(from urlRequest: URLRequest) async throws  -> (Data, URLResponse) {
        return try await data(for: urlRequest)
    }
}
