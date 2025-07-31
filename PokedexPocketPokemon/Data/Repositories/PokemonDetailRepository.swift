//
//  PokemonDetailRepository.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift
import PokedexPocketCore

public class PokemonDetailRepository: PokemonDetailRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    public func getPokemonDetail(id: Int) -> Observable<PokemonDetail> {
        let endpoint = PokemonEndpoint.pokemonDetail(id: id)
        return networkService
            .request(endpoint, responseType: PokemonDetailResponse.self)
            .map { $0.toDomain() }
    }

    public func getPokemonDetail(url: String) -> Observable<PokemonDetail> {
        let endpoint = PokemonEndpoint.pokemonDetailByURL(url: url)
        return networkService
            .request(endpoint, responseType: PokemonDetailResponse.self)
            .map { $0.toDomain() }
    }
}
