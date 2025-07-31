//
//  SearchPokemonUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift

public protocol SearchPokemonUseCaseProtocol {
    func execute(query: String) -> Observable<[PokemonListItem]>
}

public class SearchPokemonUseCase: SearchPokemonUseCaseProtocol {
    private let repository: PokemonListRepositoryProtocol

    public init(repository: PokemonListRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(query: String) -> Observable<[PokemonListItem]> {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Observable.just([])
        }

        return repository.searchPokemon(query: query)
    }
}
