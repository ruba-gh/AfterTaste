//
//  PurchaseResult.swift
//  AfterTaste
//
//  Created by Raghad Aljuid on 02/02/1448 AH.
//
import SwiftUI

struct PurchaseResult: View {
    @State private var showCoolDownPopup = false
    @State private var selectedItem: CooldownItem?
    @State private var goToCooldown = false
    @StateObject private var cooldownViewModel = CooldownViewModel()
    @ObservedObject var viewModel: PurchaseViewModel

    private let timerColor = Color(
        red: 176 / 255,
        green: 115 / 255,
        blue: 131 / 255
    )

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                resultCard
                    .padding(.horizontal, 16)
                    .padding(.top, 40)
                    .padding(.bottom, 58)
            }

            if showCoolDownPopup {
                coolDownPopup
            }
        }
        .navigationTitle(viewModel.resultTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    // MARK: - Result Card

    private var resultCard: some View {
        VStack(spacing: 0) {
            Text("This purchase equals")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 16)

            timeCounter
                .padding(.top, 10)

            Divider()
                .overlay(.white.opacity(0.18))
                .padding(.horizontal, 18)
                .padding(.top, 18)

            choiceRow(
                leftTitle: "Impulse",
                leftSelected: viewModel.purchaseType == .impulse,
                rightTitle: "Planned",
                rightSelected: viewModel.purchaseType == .planned,
                leftAction: {
                    viewModel.purchaseType = .impulse
                },
                rightAction: {
                    viewModel.purchaseType = .planned
                }
            )

            Divider()
                .overlay(.white.opacity(0.10))
                .padding(.horizontal, 18)

            choiceRow(
                leftTitle: "One time",
                leftSelected: viewModel.paymentType == .oneTime,
                rightTitle: "Subscription",
                rightSelected: viewModel.paymentType == .subscription,
                leftAction: {
                    viewModel.paymentType = .oneTime
                },
                rightAction: {
                    viewModel.paymentType = .subscription
                }
            )

            Divider()
                .overlay(.white.opacity(0.10))
                .padding(.horizontal, 18)

            choiceRow(
                leftTitle: "Need",
                leftSelected: viewModel.purchasePriority == .need,
                rightTitle: "Want",
                rightSelected: viewModel.purchasePriority == .want,
                leftAction: {
                    viewModel.purchasePriority = .need
                },
                rightAction: {
                    viewModel.purchasePriority = .want
                }
            )

            Divider()
                .overlay(.white.opacity(0.18))
                .padding(.horizontal, 18)

            urgencySlider
                .padding(.horizontal, 18)
                .padding(.top, 12)

            reasonField
                .padding(.horizontal, 18)
                .padding(.top, 18)

            lifeExpectancyRow
                .padding(.horizontal, 18)
                .padding(.top, 14)

            actionButtons
                .padding(.horizontal, 18)
                .padding(.top, 22)
                .padding(.bottom, 18)
        }
        .background(Color.white.opacity(0.11))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
        )
    }

    // MARK: - Time Counter

    private var timeCounter: some View {
        HStack(alignment: .top, spacing: 8) {
            timeBox(
                value: viewModel.daysRequired,
                label: "Day"
            )

            separator

            timeBox(
                value: viewModel.hoursRequired,
                label: "Hours"
            )

            separator

            timeBox(
                value: viewModel.minutesRequired,
                label: "Minutes"
            )
        }
    }

    private func timeBox(
        value: Int,
        label: String
    ) -> some View {
        VStack(spacing: 4) {
            Text(String(format: "%02d", value))
                .font(
                    .system(
                        size: 30,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(timerColor)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                )

            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.85))
        }
    }

    private var separator: some View {
        Text(":")
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(.white)
            .padding(.top, 9)
    }

    // MARK: - Choices

    private func choiceRow(
        leftTitle: String,
        leftSelected: Bool,
        rightTitle: String,
        rightSelected: Bool,
        leftAction: @escaping () -> Void,
        rightAction: @escaping () -> Void
    ) -> some View {
        HStack {
            selectionButton(
                title: leftTitle,
                isSelected: leftSelected,
                action: leftAction
            )

            Spacer()

            selectionButton(
                title: rightTitle,
                isSelected: rightSelected,
                action: rightAction
            )
        }
        .padding(.horizontal, 22)
        .frame(height: 64)
    }

    private func selectionButton(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Circle()
                    .stroke(
                        isSelected
                            ? Color("Color")
                            : Color.white.opacity(0.25),
                        lineWidth: 3
                    )
                    .frame(width: 22, height: 22)
                    .overlay {
                        if isSelected {
                            Circle()
                                .fill(Color("Color"))
                                .frame(width: 10, height: 10)
                        }
                    }

                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Urgency

    private var urgencySlider: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Not Urgent")

                Spacer()

                Text("Urgent")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white.opacity(0.55))

            Slider(
                value: $viewModel.urgency,
                in: 0...1
            )
            .tint(Color("Color"))
        }
    }

    // MARK: - Reason

    private var reasonField: some View {
        HStack {
            TextField(
                "",
                text: $viewModel.reason,
                prompt: Text("Explain why you want it")
                    .foregroundStyle(.white.opacity(0.5))
            )
            .foregroundStyle(.white)

            Image(systemName: "mic.fill")
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 18)
        .frame(height: 64)
        .background(Color.white.opacity(0.08))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
    }

    // MARK: - Life Expectancy

    private var lifeExpectancyRow: some View {
        HStack(spacing: 12) {
            TextField(
                "",
                text: $viewModel.lifeExpectancy,
                prompt: Text("Life expectation")
                    .foregroundStyle(.white.opacity(0.5))
            )
            .keyboardType(.decimalPad)
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(Color.white.opacity(0.08))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )

            Menu {
                ForEach(
                    ["times", "days", "months", "years"],
                    id: \.self
                ) { unit in
                    Button(unit) {
                        viewModel.lifeExpectancyUnit = unit
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(viewModel.lifeExpectancyUnit)

                    Image(systemName: "chevron.down")
                }
                .foregroundStyle(.white.opacity(0.65))
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(Color.white.opacity(0.08))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button("Save for later") {

                let item = CooldownItem(
                    itemName: viewModel.resultTitle,
                    price: viewModel.resultPrice,
                    createdAt: Date(),
                    expiresAt: Date().addingTimeInterval(60 * 30)
                )
                cooldownViewModel.addItem(
                    name: viewModel.resultTitle,
                    price: viewModel.resultPrice,
                    cooldownHours: 24
                )
                withAnimation(.easeInOut(duration: 0.20)) {
                    showCoolDownPopup = true
                }

            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color("Color"))
            .clipShape(Capsule())

            Button("Buy anyway") {
                // نضيف الإجراء لاحقًا
            }
            .foregroundStyle(Color("Color"))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.white.opacity(0.08))
            .clipShape(Capsule())
            
        }
        .font(.system(size: 16, weight: .medium))
    }

    // MARK: - Cool Down Popup

    private var coolDownPopup: some View {
        ZStack {
            // تعتيم الصفحة الخلفية
            Color.black.opacity(0.78)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Saved to your cool-down list")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 30)

                Text(
                    "Come back in 24 hours and decide with a\nclearer mind."
                )
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.80))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.top, 5)

                Button {
                    withAnimation(.easeInOut(duration: 0.20)) {
                        showCoolDownPopup = false
                    }
                    // لاحقًا نضيف الانتقال إلى Drafts داخل Decisions
                } label: {
                    Text("Ok!")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 34)
                .padding(.top, 26)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: 350)
            .background(
                // لون داكن ثابت لبطاقة البوب‑أب
                Color(red: 0.16, green: 0.16, blue: 0.18)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )
            .overlay(
                // حد خفيف لزيادة التباين مثل الصورة
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
            )
            .padding(.horizontal, 28)
        }
        .transition(
            .opacity.combined(
                with: .scale(scale: 0.96)
            )
        )
        .zIndex(10)
    }
}

#Preview {
    NavigationStack {
        PurchaseResult(
            viewModel: PurchaseViewModel()
        )
        .preferredColorScheme(.dark)
    }
}
