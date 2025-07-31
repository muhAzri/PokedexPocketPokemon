//
//  PokemonListViewModel.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import Combine
internal import RxSwift
internal import RxCocoa

public class PokemonListViewModel: ObservableObject {
    @Published public var pokemonList: [PokemonListItem] = []
    @Published public var isLoading = false
    @Published public var error: Error?
    @Published public var isSearching = false
    private let searchTextSubject = BehaviorSubject<String>(value: "")
    public var searchText: String = "" {
        didSet {
            searchTextSubject.onNext(searchText)
        }
    }

    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    private let searchPokemonUseCase: SearchPokemonUseCaseProtocol
    private let disposeBag = DisposeBag()

    private var currentOffset = 0
    private let pageSize = 1302
    private var hasMoreData = true
    private var allPokemon: [PokemonListItem] = []

    public init(
        getPokemonListUseCase: GetPokemonListUseCaseProtocol,
        searchPokemonUseCase: SearchPokemonUseCaseProtocol
    ) {
        self.getPokemonListUseCase = getPokemonListUseCase
        self.searchPokemonUseCase = searchPokemonUseCase

        setupSearchBinding()
        loadInitialData()
    }

    private func setupSearchBinding() {
        searchTextSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.searchPokemon(query: query)
            })
            .disposed(by: disposeBag)
    }

    public func loadInitialData() {
        currentOffset = 0
        hasMoreData = false
        loadPokemonList()
    }

    public func refreshData() {
        currentOffset = 0
        hasMoreData = false
        allPokemon.removeAll()
        pokemonList.removeAll()
        loadPokemonList()
    }

    public func loadMoreIfNeeded(currentItem: PokemonListItem) {
        // No pagination needed since we load all Pokemon at once
        return
    }

    private func loadPokemonList() {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        getPokemonListUseCase
            .execute(offset: currentOffset, limit: pageSize)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemonListResponse in
                    guard let self = self else { return }

                    self.allPokemon = pokemonListResponse.results
                    self.pokemonList = pokemonListResponse.results
                    self.hasMoreData = false
                    self.isLoading = false
                },
                onError: { [weak self] error in
                    self?.error = error
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }

    private func searchPokemon(query: String) {
        if query.isEmpty {
            pokemonList = allPokemon
            isSearching = false
            return
        }

        isSearching = true

        searchPokemonUseCase
            .execute(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] filteredResults in
                    self?.pokemonList = filteredResults
                    self?.isSearching = false
                },
                onError: { [weak self] error in
                    self?.error = error
                    self?.isSearching = false
                }
            )
            .disposed(by: disposeBag)
    }

    public func retry() {
        error = nil
        if searchText.isEmpty {
            loadInitialData()
        } else {
            searchPokemon(query: searchText)
        }
    }
}
