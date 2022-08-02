//
//  PokenmonConverter.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import Foundation

private enum RegexType: String, CaseIterable {
    case pokemon = "^%@pokemon/(?<id>\\d+)"
    
    func regexPattern(domain: String) -> String {
        switch self {
        case .pokemon:
            return String(format: rawValue, domain)
        }
    }
}

struct URLParser {
    enum TargetType {
        case pokemon(Pokemon)
        case undefined
    }
    
    let domain: String
    
    init(domain: String) {
        self.domain = domain
    }
    
    func make(url: URL) -> TargetType {
        let urlString = url.absoluteString.lowercased()
        
        for type in RegexType.allCases {
            if let regex = try? NSRegularExpression(pattern: type.regexPattern(domain: domain), options: []),
               let match = regex.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: urlString.utf8.count)),
               let range = Range(match.range(withName: "id"), in: urlString),
               let id = Int(urlString[range]) {
                switch type {
                case .pokemon:
                    return .pokemon(Pokemon(id: id))
                }
            }
        }

        return .undefined
    }
}
