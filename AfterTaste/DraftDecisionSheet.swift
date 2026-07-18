//
//  DraftDecisionSheet.swift
//  AfterTaste
//
//  Created by Assistant on 18/07/2026.
//

import SwiftUI

struct DraftDecisionSheet: View {

    let draft: PurchaseDraft

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var draftStore: DraftStore
    @EnvironmentObject var cooldownViewModel: CooldownViewModel

    // حالات محلية قابلة للتعديل لعرض التغييرات فورًا
    @State private var itemName: String = ""
    @State private var priceText: String = ""
    @State private var purchaseType: PurchaseType = .planned
    @State private var paymentType: PaymentType = .oneTime
    @State private var purchasePriority: PurchasePriority = .want
    @State private var urgency: Double = 0
    @State private var reaction: String = ""

    @State private var showMoreTimeSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Drag indicator
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 42, height: 5)
                        .padding(.top, 8)

                    // Title
                    Text("Item Details")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    // Product card (اسم + سعر + Days to Cool)
                    productCard
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    // Choice row (Want / Planned / One Time / Not Urgent)
                    choicesRow
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    // First reaction
                    firstReactionSection
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    Spacer()

                    // Bottom buttons
                    actionButtons
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
            .sheet(isPresented: $showMoreTimeSheet) {
                MoreTimeDraftSheet {
                    let price = Double(priceText.replacingOccurrences(of: ",", with: "")) ?? 0
                    cooldownViewModel.addItem(
                        name: itemName.isEmpty ? "Unnamed item" : itemName,
                        price: price,
                        cooldownHours: 24
                    )
                    dismiss()
                }
                .environmentObject(cooldownViewModel)
            }
            .onAppear {
                loadFromDraft()
            }
        }
    }

    // MARK: - Subviews

    // بطاقة العنصر باللون الرمادي الداكن (مثل التصميم)، مع كبسولة التدرج على اليمين
    private var productCard: some View {
        HStack(spacing: 14) {
            Text(itemName.isEmpty ? "Unnamed item" : itemName)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(1)

            Text(formattedPrice(priceText))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)

            Spacer()

            Text("2 Days to Cool")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: [
                            Color("Color"),
                            Color(red: 0.89, green: 0.44, blue: 0.30)
                        ],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color("Button"))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
    }

    private var choicesRow: some View {
        VStack(spacing: 12) {
            // الصف الأول: Want / Planned
            HStack {
                pillChoice(
                    title: "Want",
                    isSelected: purchasePriority == .want
                ) { purchasePriority = .want }

                Spacer()

                pillChoice(
                    title: "Planned",
                    isSelected: purchaseType == .planned
                ) { purchaseType = .planned }
            }

            // الصف الثاني: One Time / Not Urgent
            HStack {
                pillChoice(
                    title: "One Time",
                    isSelected: paymentType == .oneTime
                ) { paymentType = .oneTime }

                Spacer()

                pillChoice(
                    title: "Not Urgent",
                    isSelected: urgency <= 0.01
                ) { urgency = 0 }
            }
        }
        .padding(.horizontal, 4)
    }

    private func pillChoice(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(
                    ZStack {
                        Color("Button")
                        if isSelected {
                            LinearGradient(
                                colors: [
                                    Color("Color"),
                                    Color(red: 0.89, green: 0.44, blue: 0.30)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                    }
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var firstReactionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("First reaction")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)

            HStack(alignment: .top) {
                TextField(
                    "",
                    text: $reaction,
                    prompt: Text("I really like it...")
                        .foregroundColor(.white.opacity(0.5))
                )
                .foregroundColor(.white)
                .lineLimit(4)

                Button {} label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.08))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
            )
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button {
                dismiss()
            } label: {
                Text("Buy")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color("Color"))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button {
                showMoreTimeSheet = true
            } label: {
                Text("More time")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.99, green: 0.47, blue: 0.30),
                                Color(red: 0.97, green: 0.36, blue: 0.18)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button {
                draftStore.removeDraft(draft)
                dismiss()
            } label: {
                Text("Don't buy")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Helpers

    private func loadFromDraft() {
        itemName = draft.itemName
        priceText = draft.price
        purchaseType = draft.purchaseType
        paymentType = draft.paymentType
        purchasePriority = draft.purchasePriority
        urgency = draft.urgency
        reaction = draft.reason
    }

    private func formattedPrice(_ price: String) -> String {
        let clean = price.trimmingCharacters(in: .whitespacesAndNewlines)
        if clean.isEmpty { return "$0" }
        if let value = Double(clean.replacingOccurrences(of: ",", with: "")) {
            return String(format: "$%.0f", value)
        }
        return "$\(clean)"
    }
}

// MARK: - More Time (Draft) Placeholder

private struct MoreTimeDraftSheet: View {
    var onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 18) {
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 42, height: 5)
                    .padding(.top, 8)

                Text("Choose another cooldown")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text("Give yourself a little more time before deciding.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    onConfirm()
                    dismiss()
                } label: {
                    Text("Add 24 hours")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 6)

                Spacer()
            }
            .padding(24)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    DraftDecisionSheet(
        draft: PurchaseDraft(
            id: UUID(),
            itemName: "Elephant Plushie",
            price: "30",
            purchaseType: .planned,
            paymentType: .oneTime,
            purchasePriority: .want,
            urgency: 0,
            reason: "I really like it. It seems a bit pricey and I haven’t used it yet, but I’d still consider buying it.",
            lifeExpectancy: "2",
            lifeExpectancyUnit: "years"
        )
    )
    .environmentObject(DraftStore())
    .environmentObject(CooldownViewModel())
    .preferredColorScheme(.dark)
}
