//
//  PurchaseViewModel.swift
//  AfterTaste
//

import Foundation
import Combine

@MainActor
final class PurchaseViewModel: ObservableObject {

    // MARK: - Purchase Details

    @Published var price: String = ""
    @Published var itemName: String = ""

    // This value comes from Setup / Settings
    @Published var hourlyRate: Double = 0

    @Published var purchaseType: PurchaseType = .planned
    @Published var paymentType: PaymentType = .oneTime
    @Published var purchasePriority: PurchasePriority = .want
    @Published var urgency: Double = 0

    @Published var reason: String = ""
    @Published var lifeExpectancy: String = ""
    @Published var lifeExpectancyUnit: String = "times"


    // MARK: - Init

    init() {
        loadSavedHourlyRate()
    }


    // MARK: - Saved Hourly Rate

    func loadSavedHourlyRate() {
        hourlyRate = UserDefaults.standard.double(
            forKey: "afterTaste.hourlyRate"
        )
    }


    // MARK: - Validation

    var canAnalyze: Bool {
        let cleanName = itemName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        return !cleanName.isEmpty &&
        numericPrice > 0
    }


    // MARK: - Price

    var numericPrice: Double {
        let normalizedPrice = price
            .replacingOccurrences(
                of: ",",
                with: ""
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        return Double(normalizedPrice) ?? 0
    }

    var resultPrice: Double {
        numericPrice
    }


    // MARK: - Time Equivalent

    /// Example:
    /// Price = 120
    /// Hourly rate = 30
    /// 120 / 30 = 4 hours
    var totalMinutesRequired: Int {
        guard hourlyRate > 0,
              numericPrice > 0
        else {
            return 0
        }

        let totalHours =
            numericPrice / hourlyRate

        return Int(
            (totalHours * 60).rounded()
        )
    }

    var daysRequired: Int {
        totalMinutesRequired / 1_440
    }

    var hoursRequired: Int {
        (totalMinutesRequired % 1_440) / 60
    }

    var minutesRequired: Int {
        totalMinutesRequired % 60
    }


    // MARK: - Result

    var resultTitle: String {
        let name = itemName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        return name.isEmpty
        ? "Item Result"
        : "\(name) Result"
    }


    // MARK: - Draft

    var hasDraftContent: Bool {

        let hasItemName =
        !itemName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty

        let hasPrice =
        !price
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty

        let hasReason =
        !reason
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty

        let hasLifeExpectancy =
        !lifeExpectancy
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty

        return hasItemName ||
        hasPrice ||
        hasReason ||
        hasLifeExpectancy
    }


    // MARK: - Analyze

    func analyzePurchase() {
        guard canAnalyze else {
            return
        }

        // Refresh in case user changed income
        // from Settings.
        loadSavedHourlyRate()

        print(
            """
            Analyzing \(itemName)
            Price: \(numericPrice)
            Hourly rate: \(hourlyRate)
            Time equivalent: \(daysRequired)d \(hoursRequired)h \(minutesRequired)m
            """
        )
    }
}


// MARK: - Purchase Type

enum PurchaseType: String, CaseIterable {
    case impulse = "Impulse"
    case planned = "Planned"
}


// MARK: - Payment Type

enum PaymentType: String, CaseIterable {
    case oneTime = "One time"
    case subscription = "Subscription"
}


// MARK: - Purchase Priority

enum PurchasePriority: String, CaseIterable {
    case need = "Need"
    case want = "Want"
}
