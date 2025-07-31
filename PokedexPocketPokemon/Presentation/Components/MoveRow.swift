//
//  MoveRow.swift
//  PokedexPocketPokemon
//
//  Created by Azri on 31/07/25.
//

import SwiftUI

public struct MoveRow: View {
    let move: PokemonMove

    public init(move: PokemonMove) {
        self.move = move
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(move.formattedName)
                    .font(.body)
                    .fontWeight(.medium)

                Text(move.formattedLearnMethod)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview("Move Row") {
    let sampleMove = PokemonMove(
        name: "thunderbolt",
        learnMethod: "level-up",
        level: 15
    )

    VStack {
        MoveRow(move: sampleMove)
        MoveRow(move: sampleMove)
    }
    .padding()
}