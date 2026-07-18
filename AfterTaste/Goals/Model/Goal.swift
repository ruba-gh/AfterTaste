//
//  Goal.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//


import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID
    var name: String
    var targetCost: Double
    var savedAmount: Double
    var iconName: String      // SF Symbol name
    var colorHex: String      // stored as hex so it survives Codable

    var progress: Double {
        guard targetCost > 0 else { return 0 }
        return min(savedAmount / targetCost, 1.0)
    }

    init(
        id: UUID = UUID(),
        name: String,
        targetCost: Double,
        savedAmount: Double = 0,
        iconName: String = "target",
        colorHex: String = "#8B7CF6"
    ) {
        self.id = id
        self.name = name
        self.targetCost = targetCost
        self.savedAmount = savedAmount
        self.iconName = iconName
        self.colorHex = colorHex
    }
}
