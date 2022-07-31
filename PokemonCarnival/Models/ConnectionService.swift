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
    
    func pokemonsPaginator() -> Paginator<Pokemon> {
        Paginator(networkProvider: networkProvider, decoder: decoder, endPoint: PokemonEndPoint.fetchPokemons)
    }
}
