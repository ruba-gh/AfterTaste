//
//  PurchaseResult.swift
//  AfterTaste
//
//  Created by Raghad Aljuid on 02/02/1448 AH.
//

import SwiftUI

struct PurchaseResult: View {

    // MARK: - State

    @State
    private var showCoolDownPopup = false

    @State
    private var goToCooldown = false

    @State
    private var didFinishPurchase = false

    @State
    private var didSaveDraft = false


    // MARK: - Environment

    @EnvironmentObject
    var cooldownViewModel:
        CooldownViewModel

    @EnvironmentObject
    private var draftStore:
        DraftStore


    // MARK: - View Model

    @ObservedObject
    var viewModel:
        PurchaseViewModel


    // MARK: - Timer Color

    private let timerColor =
        Color(
            red: 176 / 255,
            green: 115 / 255,
            blue: 131 / 255
        )


    // MARK: - Cost Per Unit

    private var costPerUnitText:
        String? {

        let count =
            Double(
                viewModel
                    .lifeExpectancy
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )
            )
            ?? 0


        guard count > 0
        else {
            return nil
        }


        let price =
            viewModel.numericPrice


        guard price > 0
        else {
            return nil
        }


        switch
            viewModel.lifeExpectancyUnit {

        case "times":

            let perUse =
                price / count

            return String(
                format:
                    "≈ $%.2f per use",
                perUse
            )


        case "days":

            let perDay =
                price / count

            return String(
                format:
                    "≈ $%.2f per day",
                perDay
            )


        case "months":

            let perMonth =
                price / count

            return String(
                format:
                    "≈ $%.2f per month",
                perMonth
            )


        case "years":

            let perYear =
                price / count

            return String(
                format:
                    "≈ $%.2f per year",
                perYear
            )


        default:

            return nil
        }
    }


    // MARK: - Body

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()


            VStack(spacing: 0) {

                resultCard
                    .padding(
                        .horizontal,
                        16
                    )
                    .padding(
                        .top,
                        40
                    )
                    .padding(
                        .bottom,
                        58
                    )
            }


            if showCoolDownPopup {

                coolDownPopup
            }
        }
        .navigationTitle(
            viewModel.resultTitle
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbarColorScheme(
            .dark,
            for: .navigationBar
        )
        .toolbarBackground(
            Color.black,
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
        .navigationDestination(
            isPresented:
                $goToCooldown
        ) {

            CooldownView()
        }
        .onAppear {

            // Ensure we always use
            // the latest saved hourly rate.
            viewModel.loadSavedHourlyRate()
        }
        .onDisappear {

            saveDraftIfNeeded()
        }
    }


    // MARK: - Result Card

    private var resultCard: some View {

        VStack(spacing: 0) {

            Text(
                "This purchase equals"
            )
            .font(
                .system(
                    size: 23,
                    weight: .bold
                )
            )
            .foregroundStyle(.white)
            .padding(.top, 16)


            // Shows calculated time immediately
            timeCounter
                .padding(.top, 10)


            Divider()
                .overlay(
                    .white.opacity(0.18)
                )
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    18
                )


            // MARK: Impulse / Planned

            choiceRow(
                leftTitle:
                    "Impulse",

                leftSelected:
                    viewModel
                    .purchaseType
                    == .impulse,

                rightTitle:
                    "Planned",

                rightSelected:
                    viewModel
                    .purchaseType
                    == .planned,

                leftAction: {

                    viewModel
                        .purchaseType =
                        .impulse
                },

                rightAction: {

                    viewModel
                        .purchaseType =
                        .planned
                }
            )


            Divider()
                .overlay(
                    .white.opacity(0.10)
                )
                .padding(
                    .horizontal,
                    18
                )


            // MARK: One Time / Subscription

            choiceRow(
                leftTitle:
                    "One time",

                leftSelected:
                    viewModel
                    .paymentType
                    == .oneTime,

                rightTitle:
                    "Subscription",

                rightSelected:
                    viewModel
                    .paymentType
                    == .subscription,

                leftAction: {

                    viewModel
                        .paymentType =
                        .oneTime
                },

                rightAction: {

                    viewModel
                        .paymentType =
                        .subscription
                }
            )


            Divider()
                .overlay(
                    .white.opacity(0.10)
                )
                .padding(
                    .horizontal,
                    18
                )


            // MARK: Need / Want

            choiceRow(
                leftTitle:
                    "Need",

                leftSelected:
                    viewModel
                    .purchasePriority
                    == .need,

                rightTitle:
                    "Want",

                rightSelected:
                    viewModel
                    .purchasePriority
                    == .want,

                leftAction: {

                    viewModel
                        .purchasePriority =
                        .need
                },

                rightAction: {

                    viewModel
                        .purchasePriority =
                        .want
                }
            )


            Divider()
                .overlay(
                    .white.opacity(0.18)
                )
                .padding(
                    .horizontal,
                    18
                )


            urgencySlider
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    12
                )


            reasonField
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    18
                )


            lifeExpectancySection
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    14
                )


            actionButtons
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    22
                )
                .padding(
                    .bottom,
                    18
                )
        }
        .background(
            Color.white.opacity(0.11)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
        )
    }


    // MARK: - Time Equivalent

    private var timeCounter:
        some View {

        Group {

            if viewModel.hourlyRate > 0 {

                HStack(
                    alignment: .top,
                    spacing: 8
                ) {

                    timeBox(
                        value:
                            viewModel
                            .daysRequired,

                        label:
                            "Day"
                    )


                    separator


                    timeBox(
                        value:
                            viewModel
                            .hoursRequired,

                        label:
                            "Hours"
                    )


                    separator


                    timeBox(
                        value:
                            viewModel
                            .minutesRequired,

                        label:
                            "Minutes"
                    )
                }
                .accessibilityLabel(
                    "Work time equivalent"
                )
                .accessibilityValue(
                    """
                    \(viewModel.daysRequired) days, \(viewModel.hoursRequired) hours, \(viewModel.minutesRequired) minutes
                    """
                )

            } else {

                VStack(spacing: 8) {

                    Image(
                        systemName:
                            "exclamationmark.circle"
                    )
                    .font(
                        .system(size: 20)
                    )
                    .foregroundStyle(
                        Color("Color")
                    )


                    Text(
                        """
                        Add your hourly rate in Settings to calculate the time equivalent.
                        """
                    )
                    .font(
                        .system(size: 13)
                    )
                    .foregroundStyle(
                        .white.opacity(0.6)
                    )
                    .multilineTextAlignment(
                        .center
                    )
                }
                .padding(
                    .horizontal,
                    24
                )
                .padding(
                    .vertical,
                    16
                )
            }
        }
    }


    // MARK: - Time Box

    private func timeBox(
        value: Int,
        label: String
    ) -> some View {

        VStack(spacing: 4) {

            Text(
                String(
                    format:
                        "%02d",
                    value
                )
            )
            .font(
                .system(
                    size: 30,
                    weight: .bold,
                    design: .rounded
                )
            )
            .foregroundStyle(
                .white
            )
            .frame(
                width: 50,
                height: 50
            )
            .background(
                timerColor
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
            )


            Text(label)
                .font(
                    .system(size: 12)
                )
                .foregroundStyle(
                    .white.opacity(0.85)
                )
        }
    }


    private var separator:
        some View {

        Text(":")
            .font(
                .system(
                    size: 28,
                    weight: .bold
                )
            )
            .foregroundStyle(
                .white
            )
            .padding(
                .top,
                9
            )
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
                title:
                    leftTitle,

                isSelected:
                    leftSelected,

                action:
                    leftAction
            )


            Spacer()


            selectionButton(
                title:
                    rightTitle,

                isSelected:
                    rightSelected,

                action:
                    rightAction
            )
        }
        .padding(
            .horizontal,
            22
        )
        .frame(height: 64)
    }


    private func selectionButton(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {

        Button(
            action:
                action
        ) {

            HStack(spacing: 10) {

                Circle()
                    .stroke(

                        isSelected

                        ? Color("Color")

                        : Color.white
                            .opacity(0.25),

                        lineWidth: 3
                    )
                    .frame(
                        width: 22,
                        height: 22
                    )
                    .overlay {

                        if isSelected {

                            Circle()
                                .fill(
                                    Color("Color")
                                )
                                .frame(
                                    width: 10,
                                    height: 10
                                )
                        }
                    }


                Text(title)
                    .font(
                        .system(size: 16)
                    )
                    .foregroundStyle(
                        .white
                    )
            }
        }
        .buttonStyle(.plain)
    }


    // MARK: - Urgency

    private var urgencySlider:
        some View {

        VStack(spacing: 0) {

            HStack {

                Text("Not Urgent")


                Spacer()


                Text("Urgent")
            }
            .font(
                .system(
                    size: 13,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                .white.opacity(0.55)
            )


            Slider(
                value:
                    $viewModel.urgency,

                in:
                    0...1
            )
            .tint(
                Color("Color")
            )
        }
    }


    // MARK: - Reason

    private var reasonField:
        some View {

        HStack {

            TextField(
                "",
                text:
                    $viewModel.reason,

                prompt:
                    Text(
                        "Explain why you want it"
                    )
                    .foregroundStyle(
                        .white.opacity(0.5)
                    )
            )
            .foregroundStyle(
                .white
            )


            Image(
                systemName:
                    "mic.fill"
            )
            .foregroundStyle(
                .white
            )
        }
        .padding(
            .horizontal,
            18
        )
        .frame(height: 64)
        .background(
            Color.white.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
    }


    // MARK: - Life Expectancy

    private var lifeExpectancySection:
        some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            lifeExpectancyRow


            if let text =
                costPerUnitText {

                Text(text)
                    .font(
                        .system(
                            size: 12,
                            weight: .medium
                        )
                    )
                    .foregroundColor(
                        .white.opacity(0.75)
                    )
                    .padding(
                        .horizontal,
                        4
                    )
            }
        }
    }


    private var lifeExpectancyRow:
        some View {

        HStack(spacing: 12) {

            TextField(
                "",
                text:
                    $viewModel
                    .lifeExpectancy,

                prompt:
                    Text(
                        "How long will you use it/ how many times?"
                    )
                    .foregroundStyle(
                        .white.opacity(0.5)
                    )
            )
            .keyboardType(
                .decimalPad
            )
            .foregroundStyle(
                .white
            )
            .padding(
                .horizontal,
                18
            )
            .frame(height: 52)
            .background(
                Color.white.opacity(0.08)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )


            Menu {

                ForEach(
                    [
                        "times",
                        "days",
                        "months",
                        "years"
                    ],

                    id: \.self
                ) { unit in

                    Button(unit) {

                        viewModel
                            .lifeExpectancyUnit =
                            unit
                    }
                }

            } label: {

                HStack(spacing: 8) {

                    Text(
                        viewModel
                            .lifeExpectancyUnit
                    )


                    Image(
                        systemName:
                            "chevron.down"
                    )
                }
                .foregroundStyle(
                    .white.opacity(0.65)
                )
                .padding(
                    .horizontal,
                    16
                )
                .frame(height: 52)
                .background(
                    Color.white.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
            }
        }
    }


    // MARK: - Actions

    private var actionButtons:
        some View {

        HStack(spacing: 10) {

            Button(
                "Save for later"
            ) {

                didFinishPurchase =
                    true


                cooldownViewModel
                    .addItem(

                        name:
                            viewModel
                            .itemName,

                        price:
                            viewModel
                            .resultPrice,

                        cooldownHours:
                            24
                    )


                withAnimation(
                    .easeInOut(
                        duration: 0.20
                    )
                ) {

                    showCoolDownPopup =
                        true
                }
            }
            .foregroundStyle(
                .white
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 44)
            .background(
                Color("Color")
            )
            .clipShape(
                Capsule()
            )


            Button(
                "Buy anyway"
            ) {

                didFinishPurchase =
                    true
            }
            .foregroundStyle(
                Color("Color")
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 44)
            .background(
                Color.white.opacity(0.08)
            )
            .clipShape(
                Capsule()
            )
        }
        .font(
            .system(
                size: 16,
                weight: .medium
            )
        )
    }


    // MARK: - Cool Down Popup

    private var coolDownPopup:
        some View {

        ZStack {

            Color.black
                .opacity(0.78)
                .ignoresSafeArea()


            VStack(spacing: 0) {

                Text(
                    "Saved to your cool-down list"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .white
                )
                .padding(
                    .top,
                    30
                )


                Text(
                    """
                    Come back in 24 hours and decide with a
                    clearer mind.
                    """
                )
                .font(
                    .system(size: 14)
                )
                .foregroundStyle(
                    .white.opacity(0.80)
                )
                .multilineTextAlignment(
                    .center
                )
                .lineSpacing(3)
                .padding(
                    .top,
                    5
                )


                Button {

                    withAnimation(
                        .easeInOut(
                            duration: 0.20
                        )
                    ) {

                        showCoolDownPopup =
                            false
                    }


                    goToCooldown =
                        true

                } label: {

                    Text("Ok!")
                        .font(
                            .system(
                                size: 17,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            .white
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                        .frame(height: 44)
                        .background(
                            Color("Color")
                        )
                        .clipShape(
                            Capsule()
                        )
                }
                .buttonStyle(
                    .plain
                )
                .padding(
                    .horizontal,
                    34
                )
                .padding(
                    .top,
                    26
                )
                .padding(
                    .bottom,
                    24
                )
            }
            .frame(
                maxWidth: 350
            )
            .background(
                Color(
                    red: 0.16,
                    green: 0.16,
                    blue: 0.18
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )
            .overlay(

                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
                .stroke(
                    Color.white
                        .opacity(0.10),

                    lineWidth: 1
                )
            )
            .padding(
                .horizontal,
                28
            )
        }
        .transition(
            .opacity
                .combined(
                    with:
                        .scale(
                            scale: 0.96
                        )
                )
        )
        .zIndex(10)
    }


    // MARK: - Draft Saving

    private func saveDraftIfNeeded() {

        guard !didFinishPurchase
        else {
            return
        }


        guard !didSaveDraft
        else {
            return
        }


        guard viewModel.hasDraftContent
        else {
            return
        }


        draftStore.saveDraft(
            from:
                viewModel
        )


        didSaveDraft =
            true
    }
}


// MARK: - Preview

#Preview {

    let vm =
        PurchaseViewModel()


    vm.itemName =
        "AirPods"

    vm.price =
        "500"

    vm.hourlyRate =
        50


    return NavigationStack {

        PurchaseResult(
            viewModel:
                vm
        )
    }
    .environmentObject(
        CooldownViewModel()
    )
    .environmentObject(
        DraftStore()
    )
    .preferredColorScheme(
        .dark
    )
}
