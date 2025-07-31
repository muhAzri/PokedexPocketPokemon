//
//  PokemonListResponse.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

public struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItemResponse]
}

public struct PokemonListItemResponse: Codable {
    let name: String
    let url: String
}

extension PokemonListResponse {
    public func toDomain() -> PokemonList {
        PokemonList(
            count: count,
            next: next,
            previous: previous,
            results: results.map { $0.toDomain() }
        )
    }
}

extension PokemonListItemResponse {
    public func toDomain() -> PokemonListItem {
        PokemonListItem(name: name, url: url)
    }
}
