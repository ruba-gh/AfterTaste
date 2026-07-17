//
//  HistoryView.swift
//  AfterTaste
//
//  Created by Feda on 17/07/2026.
//

import SwiftUI

struct HistoryView: View {

    @EnvironmentObject var viewModel: CooldownViewModel
    @State private var selectedItem: CooldownItem?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("History")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)

                if viewModel.historyItems.isEmpty {
                    Text("No decisions yet")
                        .font(.system(size: 13))
                        .foregroundColor(.darkGrayText)
                        .padding(.horizontal, 4)
                } else {
                    ForEach(viewModel.historyItems) { item in
                        HistoryCard(item: item) {
                            selectedItem = item
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 100)
        }
        .sheet(item: $selectedItem) { item in
            HistoryDetailSheet(item: item) {
                viewModel.removeItem(item)
            }
        }
    }
}

// MARK: - History Card

struct HistoryCard: View {
    let item: CooldownItem
    var onView: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Text(item.itemName)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .lineLimit(1)

            Text(String(format: "$%.0f", item.price))
                .font(.system(size: 15))
                .foregroundColor(.gray)

            Spacer()

            Button(action: onView) {
                Text("View")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
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
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color("Button"))
        .cornerRadius(12)
    }
}

// MARK: - History Detail Sheet (View)

struct HistoryDetailSheet: View {
    let item: CooldownItem
    var onRemove: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(red: 0.10, green: 0.10, blue: 0.11)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 42, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)

                Text("Item Details")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.bottom, 24)

                // بطاقة المنتج بالتدرج
                HStack(spacing: 14) {
                    Text(item.itemName)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Spacer()

                    Text(String(format: "$%.0f", item.price))
                        .font(.system(size: 16))
                        .foregroundColor(.white)

                    Text(item.waitedText)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .padding(.horizontal, 14)
                .frame(height: 62)
                .background(
                    LinearGradient(
                        colors: [
                            Color("Color"),
                            Color(red: 0.88, green: 0.43, blue: 0.30)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                // الوسوم
                if !item.tags.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color("Button"))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 16)
                }

                // الانطباع الأول
                Text("First reaction")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.top, 22)

                Text(item.firstReaction.isEmpty ? "—" : item.firstReaction)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 64, alignment: .topLeading)
                    .padding(14)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.top, 8)

                // التأمل بعد الاستخدام
                Text("Reflection after use")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.top, 18)

                Text(item.reflectionText.isEmpty ? "—" : item.reflectionText)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 64, alignment: .topLeading)
                    .padding(14)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.top, 8)

                Spacer()

                Button {
                    onRemove()
                    dismiss()
                } label: {
                    Text("Remove")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HistoryView()
            .environmentObject(CooldownViewModel())
    }
    .preferredColorScheme(.dark)
}
