// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PokedexPocketPokemon",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "PokedexPocketPokemon",
            targets: ["PokedexPocketPokemon"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.9.0"),
        .package(url: "https://github.com/muhAzri/PokedexPocketCore", branch: "main")
    ],
    targets: [
        .target(
            name: "PokedexPocketPokemon",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "PokedexPocketCore", package: "PokedexPocketCore")
            ],
            path: "PokedexPocketPokemon"
        ),
        .testTarget(
            name: "PokedexPocketPokemonTests",
            dependencies: [
                "PokedexPocketPokemon",
                .product(name: "RxBlocking", package: "RxSwift"),
                .product(name: "RxTest", package: "RxSwift")
            ],
            path: "PokedexPocketPokemonTests"
        ),
    ]
)