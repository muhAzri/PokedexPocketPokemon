//
//  PokemonDetail.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
public import PokedexPocketCore

public struct PokemonDetail: Identifiable, Equatable, FavoritePokemonProtocol {
    public let id: Int
    public let name: String
    public let height: Int
    public let weight: Int
    public let baseExperience: Int
    public let order: Int?
    public let types: [PokemonType]
    public let stats: [PokemonStat]
    public let abilities: [PokemonAbility]
    public let moves: [PokemonMove]
    public let imageURL: String
    public let sprites: PokemonDetailSprites
    public let cries: PokemonDetailCries?
    public let species: String

    public var formattedName: String {
        name.capitalized
    }

    public var pokemonNumber: String {
        String(format: "#%03d", id)
    }
    
    // MARK: - FavoritePokemonProtocol conformance
    public var primaryType: String {
        types.first?.name ?? "Unknown"
    }

    public var heightInMeters: Double {
        Double(height) / 10.0
    }

    public var weightInKilograms: Double {
        Double(weight) / 10.0
    }

    public init(
        id: Int,
        name: String,
        height: Int,
        weight: Int,
        baseExperience: Int,
        order: Int? = nil,
        types: [PokemonType],
        stats: [PokemonStat],
        abilities: [PokemonAbility],
        moves: [PokemonMove] = [],
        imageURL: String,
        sprites: PokemonDetailSprites,
        cries: PokemonDetailCries? = nil,
        species: String
    ) {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.baseExperience = baseExperience
        self.order = order
        self.types = types
        self.stats = stats
        self.abilities = abilities
        self.moves = moves
        self.imageURL = imageURL
        self.sprites = sprites
        self.cries = cries
        self.species = species
    }

    public static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct PokemonAbility: Identifiable, Equatable, Codable {
    public let id: String
    public let name: String
    public let isHidden: Bool

    public init(name: String, isHidden: Bool = false) {
        self.id = name
        self.name = name
        self.isHidden = isHidden
    }

    public var formattedName: String {
        name.replacingOccurrences(of: "-", with: " ").capitalized
    }
}

public struct PokemonMove: Identifiable, Equatable, Codable {
    public let id: String
    public let name: String
    public let learnMethod: String
    public let level: Int

    public init(name: String, learnMethod: String, level: Int) {
        self.id = name
        self.name = name
        self.learnMethod = learnMethod
        self.level = level
    }

    public var formattedName: String {
        name.replacingOccurrences(of: "-", with: " ").capitalized
    }

    public var formattedLearnMethod: String {
        switch learnMethod {
        case "level-up":
            return "Level \(level)"
        case "machine":
            return "TM/TR"
        case "egg":
            return "Egg Move"
        case "tutor":
            return "Move Tutor"
        default:
            return learnMethod.capitalized
        }
    }
}

public struct PokemonDetailSprites: Equatable, Codable {
    public let frontDefault: String?
    public let frontShiny: String?
    public let backDefault: String?
    public let backShiny: String?
    public let officialArtwork: String?
    public let officialArtworkShiny: String?
    public let dreamWorld: String?
    public let home: String?
    public let homeShiny: String?

    public var bestQualityImage: String {
        return officialArtwork ?? home ?? dreamWorld ?? frontDefault ?? ""
    }

    public var bestQualityShinyImage: String {
        return officialArtworkShiny ?? homeShiny ?? frontShiny ?? bestQualityImage
    }

    public var bestQualityBackImage: String {
        return backDefault ?? frontDefault ?? ""
    }

    public var bestQualityBackShinyImage: String {
        return backShiny ?? frontShiny ?? bestQualityBackImage
    }

    public var allSprites: [String] {
        return [bestQualityImage, bestQualityShinyImage, bestQualityBackImage, bestQualityBackShinyImage]
            .compactMap { $0.isEmpty ? nil : $0 }
    }

    public func getCurrentSprite(isShiny: Bool, isFront: Bool) -> String {
        switch (isShiny, isFront) {
        case (false, true):
            return bestQualityImage
        case (true, true):
            return bestQualityShinyImage
        case (false, false):
            return bestQualityBackImage
        case (true, false):
            return bestQualityBackShinyImage
        }
    }

    public func getSpriteForStyle(_ style: String, isShiny: Bool, isFront: Bool) -> String {
        switch style {
        case "Official Artwork":
            if isShiny {
                return officialArtworkShiny ?? officialArtwork ?? bestQualityShinyImage
            } else {
                return officialArtwork ?? bestQualityImage
            }
        case "Home Style":
            if isShiny {
                return homeShiny ?? home ?? bestQualityShinyImage
            } else {
                return home ?? bestQualityImage
            }
        case "Game Sprites":
            switch (isShiny, isFront) {
            case (false, true):
                return frontDefault ?? bestQualityImage
            case (true, true):
                return frontShiny ?? frontDefault ?? bestQualityShinyImage
            case (false, false):
                return backDefault ?? frontDefault ?? bestQualityImage
            case (true, false):
                return backShiny ?? backDefault ?? frontShiny ?? bestQualityBackShinyImage
            }
        default:
            return bestQualityImage
        }
    }
}

public struct PokemonDetailCries: Equatable, Codable {
    public let latest: String?
    public let legacy: String?

    public var primaryCry: String? {
        return latest ?? legacy
    }
}
