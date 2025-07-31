//
//  PokemonDetailSpriteStyle.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import Foundation

public enum SpriteStyle: String, CaseIterable {
    case officialArtwork = "Official Artwork"
    case homeStyle = "Home Style"
    case gameSprites = "Game Sprites"

    public var supportsBackView: Bool {
        return self == .gameSprites
    }

    public var description: String {
        switch self {
        case .officialArtwork:
            return "High-quality official artwork"
        case .homeStyle:
            return "Pokemon Home style sprites"
        case .gameSprites:
            return "Classic pixelated game sprites"
        }
    }
}

public enum DetailTab: String, CaseIterable {
    case about = "About"
    case stats = "Stats"
    case moves = "Moves"
    case abilities = "Abilities"
}
