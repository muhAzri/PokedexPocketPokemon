//
//  GetPokemonListUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
public import RxSwift

public protocol GetPokemonListUseCaseProtocol {
    func execute(offset: Int, limit: Int) -> Observable<PokemonList>
}

public class GetPokemonListUseCase: GetPokemonListUseCaseProtocol {
    private let repository: PokemonListRepositoryProtocol

    public init(repository: PokemonListRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(offset: Int = 0, limit: Int = 20) -> Observable<PokemonList> {
        return repository.getPokemonList(offset: offset, limit: limit)
    }
}
