//
//  DecisionSheet 2.swift
//  AfterTaste
//
//  Created by Feda  on 17/07/2026.
//


//
//  DecisionSheet.swift
//  AfterTaste
//

import SwiftUI

struct DecisionSheet: View {

    let item: CooldownItem

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cooldownViewModel: CooldownViewModel

    @State private var explanation = ""
    @State private var showMoreTimeSheet = false

    var body: some View {

        NavigationStack {

            ZStack {

                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 24) {

                    // MARK: Drag Indicator

                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 42, height: 5)
                        .padding(.top, 8)

                    // MARK: Title

                    Text("Ready to decide?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    Text("Your cooldown has ended. Take one last look before making your choice.")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // MARK: Product Card

                    HStack(spacing: 16) {

                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color("Color"),
                                        Color(red: 0.89, green: 0.44, blue: 0.30)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            )

                        VStack(alignment: .leading, spacing: 6) {

                            Text(item.itemName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)

                            Text("$\(item.price, specifier: "%.2f")")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))

                        }

                        Spacer()

                    }
                    .padding()
                    .background(Color("Button"))
                    .cornerRadius(22)

                    // MARK: Explain

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Explain your decision")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        HStack(alignment: .top) {

                            TextField(
                                "Why do you still want it?",
                                text: $explanation,
                                axis: .vertical
                            )
                            .foregroundColor(.white)
                            .lineLimit(4)

                            Button {

                            } label: {

                                Image(systemName: "mic.fill")
                                    .foregroundColor(Color("Color"))

                            }

                        }
                        .padding()
                        .frame(minHeight: 110)
                        .background(Color("Button"))
                        .cornerRadius(20)

                    }

                    Spacer()

                    // MARK: Buttons

                    VStack(spacing: 12) {

                        Button {

                            // Buy action
                            dismiss()

                        } label: {

                            Text("Buy")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color("Color"),
                                            Color(red: 0.89, green: 0.44, blue: 0.30)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(26)

                        }

                        Button {

                            showMoreTimeSheet = true

                        } label: {

                            Text("More time")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color("Color"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color("Button"))
                                .cornerRadius(26)

                        }

                        Button {

                            cooldownViewModel.removeItem(item)
                            dismiss()

                        } label: {

                            Text("Don't buy")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)

                        }

                    }

                }
                .padding(24)

            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
            .sheet(isPresented: $showMoreTimeSheet) {
                MoreTimeSheet(item: item)
                    .environmentObject(cooldownViewModel)
            }

        }
    }
}

// MARK: - More Time Sheet

struct MoreTimeSheet: View {

    let item: CooldownItem

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cooldownViewModel: CooldownViewModel

    private let options: [(String, TimeInterval)] = [
        ("30 Minutes", 60 * 30),
        ("1 Hour", 60 * 60),
        ("6 Hours", 60 * 60 * 6),
        ("12 Hours", 60 * 60 * 12),
        ("1 Day", 60 * 60 * 24),
        ("3 Days", 60 * 60 * 24 * 3),
        ("1 Week", 60 * 60 * 24 * 7)
    ]

    var body: some View {

        NavigationStack {

            ZStack {

                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 24) {

                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 42, height: 5)
                        .padding(.top, 8)

                    Text("Choose another cooldown")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    Text("Give yourself a little more time before deciding.")
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)

                    VStack(spacing: 14) {

                        ForEach(options, id: \.0) { option in

                            Button {

                                cooldownViewModel.extendCooldown(
                                    item,
                                    seconds: option.1
                                )

                                dismiss()

                            } label: {

                                HStack {

                                    Text(option.0)
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium))

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white.opacity(0.4))

                                }
                                .padding()
                                .frame(height: 58)
                                .background(Color("Button"))
                                .cornerRadius(18)

                            }

                        }

                    }

                    Spacer()

                }
                .padding(24)

            }
            .presentationDetents([.medium])

        }

    }

}

// MARK: - Preview

#Preview {

    DecisionSheet(
        item: CooldownItem(
            itemName: "AirPods Pro",
            price: 249,
            createdAt: Date(),
            expiresAt: Date().addingTimeInterval(3600)
        )
    )
    .environmentObject(CooldownViewModel())

}
