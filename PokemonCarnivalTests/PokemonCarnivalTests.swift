//
//  PokemonCarnivalTests.swift
//  PokemonCarnivalTests
//
//  Created by littlema on 2022/8/3.
//

import XCTest
@testable import PokemonCarnival

class URLParserTests: XCTestCase {
    let domain = "https://pokeapi.co/api/v2/"
    var sut: URLParser!
    
    override func setUp() {
        super.setUp()
        sut = URLParser(domain: domain)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

extension URLParser.TargetType: Equatable {
    public static func == (lhs: URLParser.TargetType, rhs: URLParser.TargetType) -> Bool {
        switch (lhs, rhs) {
        case (.pokemon(let pokemonA), .pokemon(let pokemonB)):
            return pokemonA.id == pokemonB.id
        case (.undefined, .undefined):
            return true
        default:
            return false
        }
    }
}

extension URLParserTests {
    func test_URL_resource_id_is_same() {
        let fakeId = 21
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(fakeId)/")!
        let targetType = sut.make(url: url)
        
        XCTAssertEqual(targetType, .pokemon(Pokemon(id: fakeId)))
    }
    
    func test_URL_resource_id_is_not_same() {
        let fakeId1 = 21
        let fakeId2 = 5

        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(fakeId1)/")!
        let targetType = sut.make(url: url)

        XCTAssertNotEqual(targetType, .pokemon(Pokemon(id: fakeId2)))
        XCTAssertNotEqual(targetType, .undefined)
    }
    
    func test_URL_resource_is_not_integer() {
        let fakeId = "AAA"
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(fakeId)/")!
        let targetType = sut.make(url: url)

        XCTAssertEqual(targetType, .undefined)
    }
    
    func test_URL_resource_is_not_pokemon() {
        let fakeId = 21
        let url = URL(string: "https://pokeapi.co/api/v2/pikachu/\(fakeId)/")!
        let targetType = sut.make(url: url)

        XCTAssertNotEqual(targetType, .pokemon(Pokemon(id: fakeId)))
        XCTAssertEqual(targetType, .undefined)
    }
}
 
