//
//  PurchaseViewModel.swift
//  AfterTaste
//
//  Created by Assistant on 16/07/2026.
//

//
//  PurchaseViewModel.swift
//  AfterTaste
//

import Foundation
import Combine

@MainActor
final class PurchaseViewModel: ObservableObject {
    @Published var price: String = ""
    @Published var itemName: String = ""
    @Published var hourlyRate: Double = 0

    @Published var purchaseType: PurchaseType = .planned
    @Published var paymentType: PaymentType = .oneTime
    @Published var purchasePriority: PurchasePriority = .want
    @Published var urgency: Double = 0
    @Published var reason: String = ""
    @Published var lifeExpectancy: String = ""
    @Published var lifeExpectancyUnit: String = "times"

    var canAnalyze: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && numericPrice > 0
    }

    var numericPrice: Double {
        let normalizedPrice = price
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(normalizedPrice) ?? 0
    }

    var totalMinutesRequired: Int {
        guard hourlyRate > 0, numericPrice > 0 else { return 0 }
        return Int((numericPrice / hourlyRate * 60).rounded())
    }

    var daysRequired: Int { totalMinutesRequired / 1_440 }
    var hoursRequired: Int { (totalMinutesRequired % 1_440) / 60 }
    var minutesRequired: Int { totalMinutesRequired % 60 }

    var resultTitle: String {
        let name = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Item Result" : "\(name) Result"
    }

    func analyzePurchase() {
        guard canAnalyze else { return }
        print("Analyzing \(itemName) with price \(numericPrice)")
    }
}

enum PurchaseType: String, CaseIterable {
    case impulse = "Impulse"
    case planned = "Planned"
}

enum PaymentType: String, CaseIterable {
    case oneTime = "One time"
    case subscription = "Subscription"
}

enum PurchasePriority: String, CaseIterable {
    case need = "Need"
    case want = "Want"
}
