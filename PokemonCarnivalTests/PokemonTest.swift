//
//  UpdateLikeVisitor.swift
//  PokemonCarnivalTests
//
//  Created by littlema on 2022/8/3.
//

import XCTest
@testable import PokemonCarnival

class PokemonTest: XCTestCase {
    var sut: Pokemon!
    
    override func setUp() {
        super.setUp()
        
        let fakeId = 5
        sut = Pokemon(id: fakeId)
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

extension PokemonTest {
    func test_update_with_new_value_difference_with_old_value() {
        let mockUpdateLikeVisitor = MockUpdateLikeVisitor()
        sut.updateLikeVisitor = mockUpdateLikeVisitor
        
        sut.isLiked = true

        XCTAssert(mockUpdateLikeVisitor.visitorFromPokemonWithCalled)
    }
    
    func test_non_update_with_new_value_same_with_old_value() {
        let mockUpdateLikeVisitor = MockUpdateLikeVisitor()
        sut.updateLikeVisitor = mockUpdateLikeVisitor
        
        sut.isLiked = false

        XCTAssertFalse(mockUpdateLikeVisitor.visitorFromPokemonWithCalled)
    }
}

class MockUpdateLikeVisitor: UpdateLikeVisitor {
    var visitorFromPokemonWithCalled = false
    
    override func visitor(from item: Pokemon) -> Bool {
        visitorFromPokemonWithCalled = true
        return item.isLiked ?? false
    }
}
