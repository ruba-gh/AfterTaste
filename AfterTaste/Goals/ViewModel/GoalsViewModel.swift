//
//  GoalsViewModel.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//


import Foundation
import Combine
import SwiftUI

@MainActor
final class GoalsViewModel: ObservableObject {

    // MARK: - Persisted Goals

    @Published var goals: [Goal] = [] {
        didSet { saveGoals() }
    }

    // MARK: - Sheet Form State

    @Published var isAddingGoal       = false
    @Published var newGoalName        = ""
    @Published var newGoalCost        = ""
    @Published var selectedIcon: GoalIconOption = GoalIconOption.all[0]

    // MARK: - Computed

    var isFormValid: Bool {
        !newGoalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (Double(newGoalCost) ?? 0) > 0
    }

    // MARK: - Init

    init() {
        loadGoals()

        #if DEBUG
        if goals.isEmpty {
            goals = Self.mockGoals()
        }
        #endif
    }

    // MARK: - Intents

    func addGoal() {
        guard isFormValid else { return }
        let cost = Double(newGoalCost) ?? 0
        let goal = Goal(
            name: newGoalName.trimmingCharacters(in: .whitespacesAndNewlines),
            targetCost: cost,
            savedAmount: 0,
            iconName: selectedIcon.id,
            colorHex: selectedIcon.colorHex
        )
        goals.append(goal)
        resetForm()
    }

    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }

    func resetForm() {
        newGoalName    = ""
        newGoalCost    = ""
        selectedIcon   = GoalIconOption.all[0]
        isAddingGoal   = false
    }

    // MARK: - Persistence

    private let storageKey = "afterTaste.goals"

    private func saveGoals() {
        guard let data = try? JSONEncoder().encode(goals) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func loadGoals() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([Goal].self, from: data)
        else { return }
        goals = decoded
    }

    // MARK: - Mock Data

    #if DEBUG
    private static func mockGoals() -> [Goal] {
        [
            Goal(name: "New Car",   targetCost: 45_000, savedAmount: 12_430.4, iconName: "car.fill",  colorHex: "#8B7CF6"),
            Goal(name: "Prada Bag", targetCost: 1_800,  savedAmount: 128.1,    iconName: "bag.fill",  colorHex: "#F59E0B"),
        ]
    }
    #endif
}
