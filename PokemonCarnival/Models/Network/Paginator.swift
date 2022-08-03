//
//  Paginator.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Foundation
import Combine
import Moya

class Paginator<T: Codable>: NSObject {
    private var offset = 0

    @Published private(set) var items: [T] = []
    @Published private(set) var isFailure = false
    private(set) var isReachEnd = false
    private(set) var isLoading = false
    private(set) var cancellable: AnyCancellable?

    let limit: Int = 20
    let networkProvider: NetworkProvider
    let decoder: JSONDecoder
    let endPoint: TargetType
    
    init(networkProvider: NetworkProvider, decoder: JSONDecoder, endPoint: TargetType) {
        self.networkProvider = networkProvider
        self.decoder = decoder
        self.endPoint = endPoint
    }
    
    func loadNext() {
        if isLoading || isReachEnd {
            return
        }
        
        isLoading = true
        cancellable = makeRequest().sink(receiveCompletion: { [weak self] result in
            switch result {
            case .finished:
                break
            case .failure:
                self?.isFailure = true
            }
        }, receiveValue: { [weak self] value in
            guard let self = self else { return }
            self.offset += self.limit
            self.isReachEnd = value.next == nil
            self.isLoading = false
            self.items.append(contentsOf: value.results)
        })
    }
    
    func reset() {
        items = []
        isLoading = false
        isReachEnd = false
        isFailure = false
        offset = 0
        cancellable = nil
    }
    
    func makeRequest() -> AnyPublisher<PageResult<T>, Error> {
        networkProvider.requestPublisher(endPoint: endPoint, offset: offset, limit: limit)
            .map { $0.data }
            .decode(type: PageResult<T>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
