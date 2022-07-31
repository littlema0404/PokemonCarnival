//
//  ConnectionService.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Combine
import Foundation
import Moya

class ConnectionService {
    private lazy var decoder = JSONDecoder()
    private lazy var networkProvider = NetworkProvider(forTesting: false)
    
    func fetchPokemons() -> AnyPublisher<[Pokemon], Error> {
        let endPoint = PokemonEndPoint.fetchPokemons
        return networkProvider
            .requestPublisher(endPoint: endPoint)
            .map { $0.data }
            .decode(type: PageResult<Pokemon>.self, decoder: decoder)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
