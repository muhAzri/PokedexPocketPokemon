//
//  TypeBadge.swift
//  PokedexPocketPokemon
//
//  Created by Azri on 31/07/25.
//

import SwiftUI

public struct TypeBadge: View {
    let type: String
    let color: Color
    
    public init(type: String, color: Color) {
        self.type = type
        self.color = color
    }
    
    public var body: some View {
        Text(type.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(12)
    }
}

#Preview("Type Badge") {
    HStack {
        TypeBadge(type: "fire", color: .red)
        TypeBadge(type: "water", color: .blue)
        TypeBadge(type: "grass", color: .green)
    }
    .padding()
}