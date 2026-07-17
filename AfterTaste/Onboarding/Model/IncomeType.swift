//
//  IncomeType.swift
//  AfterTaste
//
//  Created by Feda  on 16/07/2026.
//


import Foundation

enum IncomeType: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case everyThreeMonths = "Every 3 Months"
    case yearly = "Yearly"
}

struct IncomeEstimator {

    static func hourlyRate(
        income: Double,
        type: IncomeType,
        workHours: Double,
        workDays: Double
    ) -> Double {

        guard workHours > 0, workDays > 0 else {
            return 0
        }

        let monthlyIncome: Double

        switch type {

        case .weekly:
            monthlyIncome = income * 4.33

        case .monthly:
            monthlyIncome = income

        case .everyThreeMonths:
            monthlyIncome = income / 3

        case .yearly:
            monthlyIncome = income / 12
        }

        let monthlyWorkingHours = workDays * 4.33 * workHours

        return monthlyIncome / monthlyWorkingHours
    }
}
