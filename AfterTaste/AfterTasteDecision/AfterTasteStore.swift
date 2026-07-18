//
//  AfterTasteStore.swift
//  AfterTaste
//
//  Created by Raghad Aljuid on 04/02/1448 AH.
//
import Foundation
import Combine

struct AfterTasteItem: Identifiable {
    let id: UUID
    var itemName: String
    var price: Double
    var purchasedAt: Date
    var reflectDate: Date
}

@MainActor
final class AfterTasteStore: ObservableObject {
    @Published var items: [AfterTasteItem] = []

    func addItem(
        name: String,
        price: Double,
        waitSeconds: TimeInterval = 15
    ) {
        let item = AfterTasteItem(
            id: UUID(),
            itemName: name,
            price: price,
            purchasedAt: Date(),
            reflectDate: Date().addingTimeInterval(waitSeconds)
        )

        items.append(item)
    }

    func removeItem(_ item: AfterTasteItem) {
        items.removeAll {
            $0.id == item.id
        }
    }
}
