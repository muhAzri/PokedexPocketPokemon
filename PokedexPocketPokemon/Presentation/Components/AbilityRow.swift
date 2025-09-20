//
//  AbilityRow.swift
//  PokedexPocketPokemon
//
//  Created by Azri on 31/07/25.
//

import SwiftUI

public struct AbilityRow: View {
    let ability: PokemonAbility

    public init(ability: PokemonAbility) {
        self.ability = ability
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ability.formattedName)
                    .font(.body)
                    .fontWeight(.medium)

                if ability.isHidden {
                    Text(NSLocalizedString("pokemon_hidden_ability", comment: "Hidden ability label"))
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview("Ability Row") {
    let sampleAbility = PokemonAbility(
        name: "static",
        isHidden: false
    )

    let hiddenAbility = PokemonAbility(
        name: "lightning-rod",
        isHidden: true
    )

    VStack {
        AbilityRow(ability: sampleAbility)
        AbilityRow(ability: hiddenAbility)
    }
    .padding()
}