//
//  CatServiceRepository.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation

//Testable
protocol CatServiceProtocol: AnyObject {
    var service: NetworkService { get }
    init(service: NetworkService)
    func fetchCats(path: String) async throws -> Result<[CatBreed], NetworkServiceError>
}


final class CatServiceRepository: CatServiceProtocol  {
    private(set) var service: NetworkService
    
    required init(service: NetworkService) {
        self.service = service
    }
    
    func fetchCats(path: String) async throws -> Result<[CatBreed], NetworkServiceError> {
        let result: Result<[CatBreed], NetworkServiceError> = try await service.get(path: path)
        return result
    }
}
