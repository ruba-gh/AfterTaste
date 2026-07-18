//
//  AfterTasteView.swift
//  AfterTaste
//
//  Created by Raghad Aljuid on 03/02/1448 AH.
//
import SwiftUI

struct AfterTasteView: View {

    @EnvironmentObject var viewModel: CooldownViewModel

    @State private var selectedItem: CooldownItem?
    @State private var reflectionText: String = ""
    @State private var reflectionChoice: ReflectionChoice?

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in

            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {
                    reflectSection(
                        items: viewModel.afterTasteReadyItems
                    )

                    waitingSection(
                        items: viewModel.afterTasteWaitingItems
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 110)
            }
        }
        .sheet(item: $selectedItem) { item in
            reflectionSheet(item: item)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(32)
        }
    }

    // MARK: - Reflect Section

    private func reflectSection(
        items: [CooldownItem]
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Reflect")
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .white.opacity(0.60)
                )
                .padding(.horizontal, 4)

            if items.isEmpty {
                emptyMessage(
                    "No items ready to reflect"
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(
                        Array(items.enumerated()),
                        id: \.element.id
                    ) { index, item in
                        reflectRow(item)

                        if index < items.count - 1 {
                            Divider()
                                .overlay(
                                    .white.opacity(0.05)
                                )
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(
                    Color.white.opacity(0.11)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24,
                        style: .continuous
                    )
                )
            }
        }
    }

    private func reflectRow(
        _ item: CooldownItem
    ) -> some View {
        HStack(spacing: 14) {
            Text(item.itemName)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()

            Text(
                String(
                    format: "$%.0f",
                    item.price
                )
            )
            .font(.system(size: 16))
            .foregroundStyle(.white)

            Button {
                reflectionText = ""
                reflectionChoice = nil
                selectedItem = item
            } label: {
                Text("Reflect")
                    .font(
                        .system(
                            size: 15,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(
                        LinearGradient(
                            colors: [
                                Color("Color"),
                                Color(
                                    red: 0.88,
                                    green: 0.43,
                                    blue: 0.30
                                )
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .frame(height: 68)
    }

    // MARK: - Waiting Section

    private func waitingSection(
        items: [CooldownItem]
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Waiting List")
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .white.opacity(0.60)
                )
                .padding(.horizontal, 4)

            if items.isEmpty {
                emptyMessage(
                    "No items in the waiting list"
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(
                        Array(items.enumerated()),
                        id: \.element.id
                    ) { index, item in
                        waitingRow(item)

                        if index < items.count - 1 {
                            Divider()
                                .overlay(
                                    .white.opacity(0.05)
                                )
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(
                    Color.white.opacity(0.11)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24,
                        style: .continuous
                    )
                )
            }
        }
    }

    private func waitingRow(
        _ item: CooldownItem
    ) -> some View {
        HStack(spacing: 14) {
            Text(item.itemName)
                .font(.system(size: 16))
                .foregroundStyle(
                    .white.opacity(0.30)
                )
                .lineLimit(1)

            Spacer()

            Text(
                String(
                    format: "$%.0f",
                    item.price
                )
            )
            .font(.system(size: 16))
            .foregroundStyle(
                .white.opacity(0.30)
            )

            Text(
                remainingLabel(item.reflectRemaining)
            )
            .font(
                .system(
                    size: 15,
                    weight: .medium,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .frame(minWidth: 92)
            .frame(height: 40)
            .background(
                Color.white.opacity(0.60)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
            )
        }
        .padding(.horizontal, 18)
        .frame(height: 68)
    }

    // MARK: - Reflection Sheet

    private func reflectionSheet(
        item: CooldownItem
    ) -> some View {
        ZStack {
            Color(
                red: 0.10,
                green: 0.10,
                blue: 0.11
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Reflection")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.top, 28)

                Text("Did you regret buying this item?")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.55))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 40)

                productSummary(item)
                    .padding(.horizontal, 24)
                    .padding(.top, 18)

                reflectionField
                    .padding(.horizontal, 24)
                    .padding(.top, 22)

                reflectionButtons(for: item)
                    .padding(.horizontal, 24)
                    .padding(.top, 22)

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }

    private func productSummary(
        _ item: CooldownItem
    ) -> some View {
        HStack(spacing: 14) {
            Text(item.itemName)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()

            Text(
                String(
                    format: "$%.0f",
                    item.price
                )
            )
            .font(.system(size: 16))
            .foregroundStyle(.white)

            Text(item.waitedText)
                .font(.system(size: 15))
                .foregroundStyle(.white)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 14)
        .frame(height: 62)
        .background(
            LinearGradient(
                colors: [
                    Color("Color"),
                    Color(
                        red: 0.88,
                        green: 0.43,
                        blue: 0.30
                    )
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
        )
    }

    private var reflectionField: some View {
        HStack {
            TextField(
                "",
                text: $reflectionText,
                prompt: Text("Explain your decision")
                    .foregroundStyle(.white.opacity(0.45))
            )
            .foregroundStyle(.white)

            Image(systemName: "mic.fill")
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 18)
        .frame(height: 72)
        .background(
            Color.white.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }

    private func reflectionButtons(
        for item: CooldownItem
    ) -> some View {
        HStack(spacing: 12) {
            Button {
                submitReflection(for: item, choice: .happy)
            } label: {
                Text("Happy with it")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color("Color"))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button {
                submitReflection(for: item, choice: .regret)
            } label: {
                Text("Regret buying it")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color("Color"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Actions

    /// إنهاء التأمل: يحفظ النص والشعور وينقل العنصر للسجل (History) ثم يغلق الشيت.
    private func submitReflection(
        for item: CooldownItem,
        choice: ReflectionChoice
    ) {
        reflectionChoice = choice
        viewModel.submitReflection(
            item,
            text: reflectionText,
            choice: choice
        )
        selectedItem = nil
    }

    // MARK: - Helpers

    private func emptyMessage(
        _ text: String
    ) -> some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundStyle(
                .white.opacity(0.30)
            )
            .padding(.horizontal, 4)
    }

    private func remainingLabel(
        _ interval: TimeInterval
    ) -> String {
        let seconds = max(0, Int(interval))

        if seconds < 60 {
            return "\(seconds) Seconds"
        }

        let minutes = seconds / 60

        if minutes < 60 {
            return "\(minutes) Minutes"
        }

        let hours = minutes / 60

        if hours < 24 {
            return "\(hours) Hours"
        }

        let days = hours / 24
        return "\(days) Days"
    }
}

// MARK: - Model



enum ReflectionChoice {
    case happy
    case regret
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()

        AfterTasteView()
            .environmentObject(CooldownViewModel())
    }
    .preferredColorScheme(.dark)
}
