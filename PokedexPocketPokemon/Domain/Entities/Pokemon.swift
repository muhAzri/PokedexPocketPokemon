//
//  Pokemon.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

public struct Pokemon: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let url: String
    public let imageURL: String
    public let types: [PokemonType]
    public let height: Int
    public let weight: Int
    public let stats: [PokemonStat]

    public init(
        id: Int,
        name: String,
        url: String,
        imageURL: String = "",
        types: [PokemonType] = [],
        height: Int = 0,
        weight: Int = 0,
        stats: [PokemonStat] = []
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.imageURL = imageURL
        self.types = types
        self.height = height
        self.weight = weight
        self.stats = stats
    }

    public var formattedName: String {
        name.capitalized
    }

    public var pokemonNumber: String {
        String(format: "#%03d", id)
    }

    public var heightInMeters: Double {
        Double(height) / 10.0
    }

    public var weightInKilograms: Double {
        Double(weight) / 10.0
    }
}

public struct PokemonType: Identifiable, Equatable, Codable {
    public let id: String
    public let name: String
    public let color: String

    public init(name: String) {
        self.id = name
        self.name = name
        self.color = PokemonType.colorForType(name)
    }

    public static func colorForType(_ type: String) -> String {
        let lowercasedType = type.lowercased()

        if let color = primaryTypeColors[lowercasedType] {
            return color
        }

        if let color = secondaryTypeColors[lowercasedType] {
            return color
        }

        return "#68A090"
    }

    private static let primaryTypeColors: [String: String] = [
        "fire": "#F08030",
        "water": "#6890F0",
        "grass": "#78C850",
        "electric": "#F8D030",
        "psychic": "#F85888",
        "ice": "#98D8D8",
        "dragon": "#7038F8",
        "dark": "#705848",
        "fairy": "#EE99AC"
    ]

    private static let secondaryTypeColors: [String: String] = [
        "normal": "#A8A878",
        "fighting": "#C03028",
        "poison": "#A040A0",
        "ground": "#E0C068",
        "flying": "#A890F0",
        "bug": "#A8B820",
        "rock": "#B8A038",
        "ghost": "#705898",
        "steel": "#B8B8D0"
    ]
}

public struct PokemonStat: Identifiable, Equatable, Codable {
    public let id: String
    public let name: String
    public let value: Int

    public init(name: String, value: Int) {
        self.id = name
        self.name = name
        self.value = value
    }
}
