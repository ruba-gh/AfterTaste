//
//  CooldownItem.swift
//  AfterTaste
//
//  Created by Feda  on 17/07/2026.
//


import Foundation

struct CooldownItem: Identifiable {

    let id = UUID()
    let itemName: String
    let price: Double
    let createdAt: Date

    var expiresAt: Date

    var isExpired: Bool {
        Date() >= expiresAt
    }

    var remainingTime: TimeInterval {
        max(0, expiresAt.timeIntervalSinceNow)
    }
}
