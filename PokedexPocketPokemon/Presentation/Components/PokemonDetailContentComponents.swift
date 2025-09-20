//
//  PokemonDetailContentComponents.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

public struct PokemonDetailContentSection: View {
    let pokemon: PokemonDetail
    @Binding var selectedTab: DetailTab

    public init(pokemon: PokemonDetail, selectedTab: Binding<DetailTab>) {
        self.pokemon = pokemon
        self._selectedTab = selectedTab
    }

    public var body: some View {
        VStack(spacing: 0) {
            Picker("Detail Tab", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 20)

            switch selectedTab {
            case .about:
                PokemonAboutSection(pokemon: pokemon)
            case .stats:
                PokemonStatsSection(pokemon: pokemon)
            case .moves:
                PokemonMovesSection(pokemon: pokemon)
            case .abilities:
                PokemonAbilitiesSection(pokemon: pokemon)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
    }
}

public struct PokemonAboutSection: View {
    let pokemon: PokemonDetail

    public init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text(NSLocalizedString("pokemon_height", comment: "Pokemon height label"))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.heightInMeters, specifier: "%.1f") \(NSLocalizedString("unit_meters", comment: "Meters unit"))")
                        .font(.body)
                        .fontWeight(.semibold)
                }

                VStack(spacing: 8) {
                    Text(NSLocalizedString("pokemon_weight", comment: "Pokemon weight label"))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.weightInKilograms, specifier: "%.1f") \(NSLocalizedString("unit_kilograms", comment: "Kilograms unit"))")
                        .font(.body)
                        .fontWeight(.semibold)
                }

                VStack(spacing: 8) {
                    Text(NSLocalizedString("pokemon_base_exp", comment: "Pokemon base experience label"))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.baseExperience)")
                        .font(.body)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                Text(NSLocalizedString("pokemon_species", comment: "Pokemon species label"))
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(pokemon.species.capitalized)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            Spacer(minLength: 40)
        }
        .padding(.vertical)
    }
}

public struct PokemonStatsSection: View {
    let pokemon: PokemonDetail

    public init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }

    private func primaryTypeColor(pokemon: PokemonDetail) -> Color {
        guard let firstType = pokemon.types.first else { return Color.gray }
        return Color(hex: firstType.color)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.stats) { stat in
                StatRow(
                    name: stat.name.replacingOccurrences(of: "-", with: " ").capitalized,
                    value: stat.value,
                    maxValue: 200,
                    color: primaryTypeColor(pokemon: pokemon)
                )
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

public struct PokemonMovesSection: View {
    let pokemon: PokemonDetail

    public init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }

    public var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(Array(pokemon.moves.prefix(20))) { move in
                MoveRow(move: move)
            }

            if pokemon.moves.count > 20 {
                Text(String.localizedStringWithFormat(NSLocalizedString("pokemon_more_moves", comment: "More moves text"), pokemon.moves.count - 20))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

public struct PokemonAbilitiesSection: View {
    let pokemon: PokemonDetail

    public init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.abilities) { ability in
                AbilityRow(ability: ability)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}
