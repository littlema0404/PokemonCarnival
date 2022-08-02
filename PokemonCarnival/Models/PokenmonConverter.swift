//
//  PokenmonConverter.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import Foundation

struct PokenmonConverter {
    enum ResultType {
        case pokemon(Pokemon)
        case undefined
    }
    
    private enum RegexType: String, CaseIterable {
        case pokemon = "^%@pokemon/(?<id>\\d+)"
        
        func regexPattern(domain: String) -> String {
            switch self {
            case .pokemon:
                return String(format: rawValue, domain)
            }
        }
    }
    
    let url: URL?
    let type: ResultType
    
    init(from item: AbstractPokemon, domain: String) {
        url = item.url.flatMap({ URL(string: $0) })
        
        if let urlString = url?.absoluteString.lowercased() {
            for type in RegexType.allCases {
                if let regex = try? NSRegularExpression(pattern: type.regexPattern(domain: domain), options: []),
                   let match = regex.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: urlString.utf8.count)),
                   let range = Range(match.range(withName: "id"), in: urlString),
                   let id = Int(urlString[range]) {
                    switch type {
                    case .pokemon:
                        var pokemon = Pokemon(id: id)
                        pokemon.name = item.name
                        self.type = .pokemon(pokemon)
                        return
                    }
                }
            }
        }

        type = .undefined
    }
}
