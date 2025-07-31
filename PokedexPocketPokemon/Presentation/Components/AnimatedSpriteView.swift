//
//  AnimatedSpriteView.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

public struct AnimatedSpriteView: View {
    let pokemon: PokemonDetail
    let selectedStyle: SpriteStyle
    let isShiny: Bool
    @Binding var isFrontView: Bool
    @Binding var rotationAngle: Double
    let onTap: () -> Void

    public init(pokemon: PokemonDetail, selectedStyle: SpriteStyle, isShiny: Bool, isFrontView: Binding<Bool>, rotationAngle: Binding<Double>, onTap: @escaping () -> Void) {
        self.pokemon = pokemon
        self.selectedStyle = selectedStyle
        self.isShiny = isShiny
        self._isFrontView = isFrontView
        self._rotationAngle = rotationAngle
        self.onTap = onTap
    }

    @State private var bounceScale: CGFloat = 1.0
    @State private var floatOffset: CGFloat = 0

    public var body: some View {
        let currentImageURL = pokemon.sprites.getSpriteForStyle(
            selectedStyle.rawValue,
            isShiny: isShiny,
            isFront: isFrontView
        )

        AsyncImage(url: URL(string: currentImageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(bounceScale)
                .offset(y: floatOffset)
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.5
                )
                .onTapGesture {
                    withAnimation(.bouncy(duration: 0.3)) {
                        bounceScale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.bouncy(duration: 0.3)) {
                            bounceScale = 1.0
                        }
                    }
                    onTap()
                }
                .onAppear {
                    startFloatingAnimation()
                }
        } placeholder: {
            ProgressView()
                .scaleEffect(1.5)
        }
    }

    private func startFloatingAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            floatOffset = -10
        }
    }
}
