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

    var canAnalyze: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        numericPrice > 0
    }

    var numericPrice: Double {
        let normalizedPrice = price
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return Double(normalizedPrice) ?? 0
    }

    func analyzePurchase() {
        guard canAnalyze else { return }

        // اربطي هنا الانتقال إلى صفحة التحليل لاحقًا.
        print("Analyzing \(itemName) with price \(numericPrice)")
    }
}
