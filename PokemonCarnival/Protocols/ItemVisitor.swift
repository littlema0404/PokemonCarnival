//
//  ItemVisitor.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/3.
//

import Foundation

protocol ItemVisitor {
    associatedtype ReturnType
    func visitor(from item: Pokemon) -> ReturnType
}
