//
//  GoalsView.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//


import SwiftUI

struct GoalsView: View {
    @StateObject private var viewModel = GoalsViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if viewModel.goals.isEmpty {
                emptyState
            } else {
                goalsList
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton
            }
        }
        .sheet(isPresented: $viewModel.isAddingGoal) {
            AddGoalSheet(viewModel: viewModel)
        }
    }

    // MARK: - Goals List

    private var goalsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(viewModel.goals) { goal in
                    GoalCardView(goal: goal)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "target")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.opacity(0.2))

            Text("No goals yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.45))

            Text("Tap + to add your first savings goal.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.3))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            viewModel.isAddingGoal = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 34, height: 34)

                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        GoalsView()
    }
    .preferredColorScheme(.dark)
}
