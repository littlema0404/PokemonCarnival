//
//  Publisher+Extensions.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import Combine

extension Publisher {
    func saveToCoreData<T: Saveable>() -> AnyPublisher<T, Self.Failure> where Output == T {
        self.handleEvents(receiveOutput: { value in
            value.saveToCoreData()
        }).eraseToAnyPublisher()
    }
    
    func saveToCoreData<T: Saveable>() -> AnyPublisher<[T], Self.Failure> where Output == [T] {
        self.handleEvents(receiveOutput: { value in
            value.forEach { $0.saveToCoreData() }
        }).eraseToAnyPublisher()
    }
}
