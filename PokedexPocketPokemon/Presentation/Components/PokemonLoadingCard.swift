//
//  PokemonLoadingCard.swift
//  PokedexPocketPokemon
//
//  Created by Azri on 31/07/25.
//

import SwiftUI

public struct PokemonLoadingCard: View {
    @State private var animateGradient = false
    
    public init() {}
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1), Color.gray.opacity(0.3)],
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
            )
            .frame(height: 120)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
    }
}