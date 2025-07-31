//
//  PokemonList.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

public struct PokemonList: Codable, Equatable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [PokemonListItem]

    public var hasNext: Bool {
        next != nil
    }

    public var hasPrevious: Bool {
        previous != nil
    }
}

public struct PokemonListItem: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.id = name
        self.name = name
        self.url = url
    }

    // Computed properties below will be ignored during encoding/decoding
    public var pokemonId: Int {
        guard let urlComponents = URLComponents(string: url),
              let pathComponents = urlComponents.path.split(separator: "/").last,
              let id = Int(pathComponents) else {
            return 0
        }
        return id
    }

    public var imageURL: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" +
            "other/official-artwork/\(pokemonId).png"
    }

    public var formattedName: String {
        name.capitalized
    }

    public var pokemonNumber: String {
        String(format: "#%03d", pokemonId)
    }
}
