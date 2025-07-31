//
//  PokemonDetailViewModel.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import Foundation
import RxSwift
import RxCocoa

public class PokemonDetailViewModel: ObservableObject {
    @Published public var pokemon: PokemonDetail?
    @Published public var isLoading = false
    @Published public var error: Error?
    @Published public var isFavorite = false
    @Published public var favoriteOperationInProgress = false

    private let pokemonId: Int
    private let getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol
    private let addFavoriteUseCase: AddFavoritePokemonUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoritePokemonUseCaseProtocol
    private let checkIsFavoriteUseCase: CheckIsFavoritePokemonUseCaseProtocol
    private let disposeBag = DisposeBag()

    public init(
        pokemonId: Int,
        getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol,
        addFavoriteUseCase: AddFavoritePokemonUseCaseProtocol,
        removeFavoriteUseCase: RemoveFavoritePokemonUseCaseProtocol,
        checkIsFavoriteUseCase: CheckIsFavoritePokemonUseCaseProtocol
    ) {
        self.pokemonId = pokemonId
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.checkIsFavoriteUseCase = checkIsFavoriteUseCase

        checkFavoriteStatus()
    }

    public func loadPokemonDetail() {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        getPokemonDetailUseCase
            .execute(id: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemon in
                    self?.pokemon = pokemon
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.error = error
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }

    public func checkFavoriteStatus() {
        checkIsFavoriteUseCase
            .execute(pokemonId: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] isFavorite in
                    self?.isFavorite = isFavorite
                },
                onError: { [weak self] error in
                    self?.error = error
                }
            )
            .disposed(by: disposeBag)
    }

    public func toggleFavorite() {
        guard let pokemon = pokemon, !favoriteOperationInProgress else {
            return
        }

        favoriteOperationInProgress = true

        if isFavorite {
            removeFavorite(pokemon: pokemon)
        } else {
            addFavorite(pokemon: pokemon)
        }
    }

    private func addFavorite(pokemon: PokemonDetail) {
        // Optimistic update
        isFavorite = true

        addFavoriteUseCase
            .execute(pokemon: pokemon)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.favoriteOperationInProgress = false
                },
                onError: { [weak self] error in
                    // Revert optimistic update on error
                    self?.isFavorite = false
                    self?.favoriteOperationInProgress = false
                    self?.error = error
                }
            )
            .disposed(by: disposeBag)
    }

    private func removeFavorite(pokemon: PokemonDetail) {
        // Optimistic update
        isFavorite = false

        removeFavoriteUseCase
            .execute(pokemonId: pokemon.id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.favoriteOperationInProgress = false
                },
                onError: { [weak self] error in
                    // Revert optimistic update on error
                    self?.isFavorite = true
                    self?.favoriteOperationInProgress = false
                    self?.error = error
                }
            )
            .disposed(by: disposeBag)
    }
}
