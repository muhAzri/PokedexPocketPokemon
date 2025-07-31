//
//  PokemonDetailRepositoryProtocol.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
public import RxSwift

public protocol PokemonDetailRepositoryProtocol {
    func getPokemonDetail(id: Int) -> Observable<PokemonDetail>
    func getPokemonDetail(url: String) -> Observable<PokemonDetail>
}
