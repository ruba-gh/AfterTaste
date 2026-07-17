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

    init() {
        #if DEBUG
        items = Self.mockItems()
        #endif
    }

    #if DEBUG
    private static func mockItems() -> [CooldownItem] {
        let now = Date()
        return [
            // Ready for decide (already expired)
            CooldownItem(itemName: "Elephant Plushie", price: 30, createdAt: now.addingTimeInterval(-3600 * 25), expiresAt: now.addingTimeInterval(-3600)),
            CooldownItem(itemName: "Coffee Mug", price: 18, createdAt: now.addingTimeInterval(-3600 * 26), expiresAt: now.addingTimeInterval(-1800)),
            // Still cooling down — one expires in 5 seconds, one much later
            CooldownItem(itemName: "Phone Case", price: 25, createdAt: now, expiresAt: now.addingTimeInterval(5)),
            CooldownItem(itemName: "Desk Lamp", price: 22, createdAt: now, expiresAt: now.addingTimeInterval(3600 * 12))
        ]
    }
    #endif

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
