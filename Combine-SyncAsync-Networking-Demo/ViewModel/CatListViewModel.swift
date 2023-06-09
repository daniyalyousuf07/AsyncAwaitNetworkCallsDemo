//
//  CatListViewModel.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation
import Combine

//Testable
protocol CatListProtocol: AnyObject {
    var catList: [CatBreed] { get  }
    func fetchCats(path: String) async throws
    init(catServiceRepository: CatServiceProtocol)
}

final class CatListViewModel: ObservableObject {
    private var task: Task<(), Error>?
    private var cancellable = Set<AnyCancellable>()
    private var catServiceRepository: CatServiceProtocol
    
    let screenTitle = "Cats"
    
    private(set) var catList: [CatBreed] = []
    
    enum Input {
        case viewDidAppear
        case refreshView
        case cancelTask
    }
    
    enum Output {
        case fetchCats(result: Result<[CatBreed], NetworkServiceError>)
        case refreshView
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    
    required init(catServiceRepository: CatServiceProtocol = CatServiceRepository(service: DefaultNetworkService(session: URLSession.shared,
                                                                                                                 urlRequest: DefaultURLRequestFactory(endpoint: DefaultEndpoint())))) {
        self.catServiceRepository = catServiceRepository
    }
    
    ///Typesafe enum based bindings
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                self?.task =  Task { [weak self] in
                    try await self?.fetchCats(path: "/v1/breeds")
                }
            case .refreshView:
                self?.output.send(.refreshView)
            case .cancelTask:
                self?.task?.cancel()
            }
        }.store(in: &cancellable)
        return output.eraseToAnyPublisher()
    }
    
    @MainActor func fetchCats(path: String) async throws {
        let result:  Result<[CatBreed], NetworkServiceError> = try await catServiceRepository.fetchCats(path: path)
        if case .success(let model) = result {
            self.catList = model
            self.output.send(.fetchCats(result: .success(model)))
        } else if case .failure(let error) = result {
            self.output.send(.fetchCats(result: .failure(error)))
        }
    }
}


extension CatListViewModel: CatListProtocol {}
