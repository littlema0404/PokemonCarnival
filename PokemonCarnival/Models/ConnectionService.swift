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
    private(set) lazy var networkProvider = NetworkProvider(forTesting: false)
    
    func fetchPokemon(id: Int) -> AnyPublisher<Pokemon, Error> {
        let endpoint = PokemonEndPoint.fetchPokemon(id: id)
        return networkProvider.requestPublisher(endPoint: endpoint)
            .map { $0.data }
            .decode(type: Pokemon.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func pokemonsPaginator() -> Paginator<GenericItem> {
        Paginator(networkProvider: networkProvider, decoder: decoder, endPoint: PokemonEndPoint.fetchPokemons)
    }
}
