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
    let expiresAt: Date

    var isExpired: Bool {
        Date() >= expiresAt
    }

    var remainingTime: TimeInterval {
        max(expiresAt.timeIntervalSinceNow, 0)
    }
}
