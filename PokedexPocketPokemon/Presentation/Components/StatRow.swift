//
//  StatRow.swift
//  PokedexPocketPokemon
//
//  Created by Azri on 31/07/25.
//

import SwiftUI

public struct StatRow: View {
    let name: String
    let value: Int
    let maxValue: Int
    let color: Color

    public init(name: String, value: Int, maxValue: Int, color: Color) {
        self.name = name
        self.value = value
        self.maxValue = maxValue
        self.color = color
    }

    public var body: some View {
        HStack {
            Text(name)
                .font(.body)
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)

            Text("\(value)")
                .font(.body)
                .fontWeight(.semibold)
                .frame(width: 40, alignment: .trailing)

            ProgressView(value: Double(value), total: Double(maxValue))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(height: 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
        }
    }
}

#Preview("Stat Row") {
    VStack {
        StatRow(name: "HP", value: 45, maxValue: 200, color: .red)
        StatRow(name: "Attack", value: 49, maxValue: 200, color: .orange)
        StatRow(name: "Defense", value: 49, maxValue: 200, color: .blue)
    }
    .padding()
}