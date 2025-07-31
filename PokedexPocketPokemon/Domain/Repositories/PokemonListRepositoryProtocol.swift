//
//  PokemonListRepositoryProtocol.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift

public protocol PokemonListRepositoryProtocol {
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonList>
    func searchPokemon(query: String) -> Observable<[PokemonListItem]>
}
