//
//  GetPokemonDetailUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
internal import RxSwift

public protocol GetPokemonDetailUseCaseProtocol {
    func execute(id: Int) -> Observable<PokemonDetail>
    func execute(url: String) -> Observable<PokemonDetail>
}

public class GetPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol {
    private let repository: PokemonDetailRepositoryProtocol

    public init(repository: PokemonDetailRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<PokemonDetail> {
        return repository.getPokemonDetail(id: id)
    }

    public func execute(url: String) -> Observable<PokemonDetail> {
        return repository.getPokemonDetail(url: url)
    }
}
