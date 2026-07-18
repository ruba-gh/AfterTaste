//
//  DraftsView.swift
//  AfterTaste
//
//  Created by Raghad Aljuid on 03/02/1448 AH.
//
import SwiftUI

struct DraftsView: View {
    @EnvironmentObject private var draftStore: DraftStore
    @EnvironmentObject private var cooldownViewModel: CooldownViewModel
    @State private var selectedDraft: PurchaseDraft?

    var body: some View {
        ScrollView(
            .vertical,
            showsIndicators: false
        ) {
            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                if draftStore.drafts.isEmpty {
                    Text("No saved drafts")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.35))
                        .frame(
                            maxWidth: .infinity,
                            alignment: .center
                        )
                        .padding(.top, 80)
                } else {
                    VStack(spacing: 0) {
                        ForEach(
                            Array(draftStore.drafts.enumerated()),
                            id: \.element.id
                        ) { index, draft in
                            draftRow(draft)

                            if index < draftStore.drafts.count - 1 {
                                Divider()
                                    .overlay(
                                        Color.white.opacity(0.06)
                                    )
                                    .padding(.horizontal, 18)
                            }
                        }
                    }
                    .background(
                        Color("Button")
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 22,
                            style: .continuous
                        )
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 110)
        }
        .sheet(item: $selectedDraft) { draft in
            DraftDecisionSheet(draft: draft)
                .environmentObject(draftStore)
                .environmentObject(cooldownViewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
                .preferredColorScheme(.dark)
        }
    }

    private func draftRow(
        _ draft: PurchaseDraft
    ) -> some View {
        HStack(spacing: 14) {
            Text(
                draft.itemName.isEmpty
                    ? "Unnamed item"
                    : draft.itemName
            )
            .font(.system(size: 15))
            .foregroundStyle(.white)
            .lineLimit(1)

            Spacer()

            Text(formattedPrice(draft.price))
                .font(.system(size: 15))
                .foregroundStyle(.white)

            Button {
                selectedDraft = draft
            } label: {
                Text("Continue")
                    .font(
                        .system(
                            size: 13,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .frame(height: 34)
                    .background(
                        LinearGradient(
                            colors: [
                                Color("Color"),
                                Color(
                                    red: 0.89,
                                    green: 0.44,
                                    blue: 0.30
                                )
                            ],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .frame(height: 62)
        .contextMenu {
            Button(role: .destructive) {
                draftStore.removeDraft(draft)
            } label: {
                Label(
                    "Delete Draft",
                    systemImage: "trash"
                )
            }
        }
    }

    private func formattedPrice(
        _ price: String
    ) -> String {
        let cleanPrice =
            price.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        if cleanPrice.isEmpty {
            return "$0"
        }

        return "$\(cleanPrice)"
    }

    private func continueDraft(
        _ draft: PurchaseDraft
    ) {
        print("Continue draft: \(draft.itemName)")

        // سيتم فتح الشيت الجديد DraftDecisionSheet أعلاه.
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        DraftsView()
            .environmentObject(DraftStore())
            .environmentObject(CooldownViewModel())
    }
    .preferredColorScheme(.dark)
}
