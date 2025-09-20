//
//  PokemonListView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
internal import PokedexPocketCore

public struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
    private let onPokemonTap: (Int, String) -> Void
    
    public init(
        viewModel: PokemonListViewModel,
        onPokemonTap: @escaping (Int, String) -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onPokemonTap = onPokemonTap
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    public var body: some View {
        VStack(spacing: 0) {
            searchBar(viewModel: viewModel)

            if viewModel.error != nil {
                errorContent(viewModel: viewModel)
            } else {
                pokemonGrid(viewModel: viewModel)
            }
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
        .onAppear {
            if viewModel.pokemonList.isEmpty && !viewModel.isLoading {
                viewModel.loadInitialData()
            }
        }
    }

    private func searchBar(viewModel: PokemonListViewModel) -> some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search Pokémon", text: Binding(
                    get: { viewModel.searchText },
                    set: { viewModel.searchText = $0 }
                ))
                .textFieldStyle(PlainTextFieldStyle())

                if !viewModel.searchText.isEmpty {
                    Button(
                        action: { viewModel.searchText = "" },
                        label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }

    private func pokemonGrid(viewModel: PokemonListViewModel) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                if viewModel.pokemonList.isEmpty && viewModel.isLoading {
                    ForEach(0..<12, id: \.self) { _ in
                        PokemonLoadingCard()
                    }
                } else if viewModel.pokemonList.isEmpty && !viewModel.searchText.isEmpty && !viewModel.isLoading {
                    emptySearchState()
                } else {
                    ForEach(viewModel.pokemonList) { pokemon in
                        PokemonCard(
                            pokemon: pokemon,
                            onTap: {
                                onPokemonTap(pokemon.pokemonId, pokemon.name)
                            }
                        )
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: pokemon)
                        }
                    }

                    if viewModel.isLoading && !viewModel.pokemonList.isEmpty {
                        ForEach(0..<6, id: \.self) { _ in
                            PokemonLoadingCard()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
            viewModel.refreshData()
        }
    }

    private func emptySearchState() -> some View {
        VStack(spacing: 16) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)

                VStack(spacing: 8) {
                    Text(NSLocalizedString("search_no_results", comment: "No results found message"))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(NSLocalizedString("search_no_results_description", comment: "No results found description"))
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorContent(viewModel: PokemonListViewModel) -> some View {
        VStack {
            Spacer()

            if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.retry()
                }
            }

            Spacer()
        }
    }
}

