//
//  CatListViewModel.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import Foundation
import Combine

protocol CatListProtocol: AnyObject {
    var service: NetworkService { get }
    var catList: [CatBreed] { get  }
    func fetchCats() async throws
    init(service: NetworkService)
}

final class CatListViewModel: ObservableObject {
    private var task: Task<(), Error>?
    private var cancellable = Set<AnyCancellable>()
    private(set) var service: NetworkService
    
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
    
    required init(service: NetworkService) {
        self.service = service
    }
    
    ///Typesafe enum based bindings
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                self?.task =  Task { [weak self] in
                    try await self?.fetchCats()
                }
            case .refreshView:
                self?.output.send(.refreshView)
            case .cancelTask:
                self?.task?.cancel()
            }
        }.store(in: &cancellable)
        return output.eraseToAnyPublisher()
    }
    
   @MainActor func fetchCats() async throws {
        let result:  Result<[CatBreed], NetworkServiceError> = try await service.get()
        if case .success(let model) = result {
            self.catList = model
            self.output.send(.fetchCats(result: .success(model)))
        } else if case .failure(let error) = result {
            self.output.send(.fetchCats(result: .failure(error)))
        }
    }
}


extension CatListViewModel: CatListProtocol {}
