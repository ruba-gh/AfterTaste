//
//  GoalCardView.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//


import SwiftUI

struct GoalCardView: View {
    let goal: Goal

    private var accentColor: Color {
        Color(hex: goal.colorHex) ?? Color("Color")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // MARK: Icon + Name
            HStack(spacing: 10) {
                Image(systemName: goal.iconName)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(accentColor)

                Text(goal.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(accentColor)

                Spacer()
            }

            // MARK: Savings Label
            HStack(spacing: 4) {
                Text("By not spending, you saved")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.55))

                Text(goal.savedAmount, format: .currency(code: "USD").precision(.fractionLength(1)))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
            }

            // MARK: Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.1))
                        .frame(height: 6)

                    Capsule()
                        .fill(accentColor)
                        .frame(width: geo.size.width * goal.progress, height: 6)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: goal.progress)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(.white.opacity(0.08), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    GoalCardView(goal: Goal(
        name: "New Car",
        targetCost: 45_000,
        savedAmount: 12_430.4,
        iconName: "car.fill",
        colorHex: "#8B7CF6"
    ))
    .padding(.horizontal, 24)
    .background(Color.black)
    .preferredColorScheme(.dark)
}
