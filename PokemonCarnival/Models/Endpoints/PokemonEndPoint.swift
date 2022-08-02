//
//  PokemonEndPoint.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Moya

enum PokemonEndPoint {
    case fetchPokemons
    case fetchPokemon(id: Int)
}

extension PokemonEndPoint: TargetType {
    var baseURL: URL {
        URL(string: "pokemon/")!
    }

    var headers: [String: String]? {
        [:]
    }

    var sampleData: Data {
        Data()
    }

    var path: String {
        switch self {
        case .fetchPokemons:
            return ""
        case .fetchPokemon(let id):
            return "\(id)/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchPokemons,
             .fetchPokemon:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .fetchPokemons,
             .fetchPokemon:
            return .requestPlain
        }
    }
}
