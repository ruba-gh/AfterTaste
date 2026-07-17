//
//  CooldownViewModel.swift
//  AfterTaste
//
//  Created by Feda  on 17/07/2026.
//


import Foundation
import Combine

final class CooldownViewModel: ObservableObject {

    @Published var items: [CooldownItem] = []

    func addItem(
        name: String,
        price: Double,
        cooldownHours: Int = 24
    ) {

        let now = Date()

        let item = CooldownItem(
            itemName: name,
            price: price,
            createdAt: now,
            expiresAt: Calendar.current.date(
                byAdding: .hour,
                value: cooldownHours,
                to: now
            )!
        )

        items.append(item)
    }

    func removeItem(_ item: CooldownItem) {
        items.removeAll { $0.id == item.id }
    }

    var readyItems: [CooldownItem] {
        items.filter(\.isExpired)
    }

    var coolingItems: [CooldownItem] {
        items.filter { !$0.isExpired }
    }
    func extendCooldown(_ item: CooldownItem, seconds: TimeInterval) {

        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index].expiresAt = Date().addingTimeInterval(seconds)
    }
}
