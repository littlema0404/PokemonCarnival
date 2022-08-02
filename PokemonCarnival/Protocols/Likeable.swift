//
//  Likeable.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/3.
//

import Foundation

protocol Likeable {
    func accept<V: ItemVisitor>(visitor: V) -> V.ReturnType
}
