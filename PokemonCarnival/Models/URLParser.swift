//
//  PokenmonConverter.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import Foundation

struct URLParser {
    enum TargetType {
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
    let targetType: TargetType
    
    init(url: URL, domain: String) {
        self.url = url
        let urlString = url.absoluteString.lowercased()
        
        for type in RegexType.allCases {
            if let regex = try? NSRegularExpression(pattern: type.regexPattern(domain: domain), options: []),
               let match = regex.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: urlString.utf8.count)),
               let range = Range(match.range(withName: "id"), in: urlString),
               let id = Int(urlString[range]) {
                switch type {
                case .pokemon:
                    self.targetType = .pokemon(Pokemon(id: id))
                    return
                }
            }
        }

        targetType = .undefined
    }
}
