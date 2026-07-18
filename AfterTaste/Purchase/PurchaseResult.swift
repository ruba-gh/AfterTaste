//
//  PurchaseResult.swift
//  AfterTaste
//

import SwiftUI

struct PurchaseResult: View {

    // MARK: - Environment

    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject
    var cooldownViewModel: CooldownViewModel

    @EnvironmentObject
    private var draftStore: DraftStore


    // MARK: - View Model

    @ObservedObject
    var viewModel: PurchaseViewModel


    // MARK: - Speech

    @StateObject
    private var speechRecognizer =
        SpeechRecognizer()


    // MARK: - State

    @State
    private var showCoolDownPopup =
        false

    @State
    private var goToCooldown =
        false

    @State
    private var didFinishPurchase =
        false

    @State
    private var didSaveDraft =
        false


    // MARK: - Navigation Title

    /// Directly connected to the name
    /// entered on the Purchase screen.
    private var itemResultTitle: String {

        let name =
            viewModel
                .itemName
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )


        return name.isEmpty
        ? "Item Result"
        : "\(name) Result"
    }


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

            return String(
                format:
                    "≈ $%.2f per use",
                price / count
            )


        case "days":

            return String(
                format:
                    "≈ $%.2f per day",
                price / count
            )


        case "months":

            return String(
                format:
                    "≈ $%.2f per month",
                price / count
            )


        case "years":

            return String(
                format:
                    "≈ $%.2f per year",
                price / count
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


            // Navigation is OUTSIDE ScrollView,
            // so it never scrolls.
            VStack(spacing: 0) {

                customNavigationBar
                    .padding(
                        .horizontal,
                        24
                    )
                    .padding(
                        .bottom,
                        18
                    )


                ScrollView(
                    .vertical,
                    showsIndicators:
                        false
                ) {

                    resultCard
                        .padding(
                            .horizontal,
                            24
                        )
                        .padding(
                            .bottom,
                            120
                        )
                }
            }


            if showCoolDownPopup {

                coolDownPopup
            }
        }
        .toolbar(
            .hidden,
            for:
                .navigationBar
        )
        .navigationDestination(
            isPresented:
                $goToCooldown
        ) {

            CooldownView()
        }
        .onAppear {

            viewModel
                .loadSavedHourlyRate()
        }
        .onDisappear {

            speechRecognizer
                .stopRecording()

            saveDraftIfNeeded()
        }

        // Whenever speech recognizer
        // produces text, update reason.
        .onReceive(
            speechRecognizer
                .$transcript
        ) { newText in

            guard
                speechRecognizer
                    .isRecording
                ||
                !newText.isEmpty
            else {
                return
            }


            viewModel.reason =
                newText
        }
    }


    // MARK: - Fixed Navigation Bar

    private var customNavigationBar:
        some View {

        ZStack {

            Text(
                itemResultTitle
            )
            .font(
                .system(
                    size: 18,
                    weight: .bold
                )
            )
            .foregroundStyle(
                .white
            )
            .lineLimit(1)
            .minimumScaleFactor(
                0.75
            )
            .padding(
                .horizontal,
                70
            )


            HStack {

                Button {

                    dismiss()

                } label: {

                    Image(
                        systemName:
                            "chevron.left"
                    )
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        .white
                    )
                    .frame(
                        width: 56,
                        height: 56
                    )
                    .background(
                        Color.white
                            .opacity(0.07)
                    )
                    .clipShape(
                        Circle()
                    )
                    .overlay {

                        Circle()
                            .stroke(
                                Color.white
                                    .opacity(0.25),
                                lineWidth: 1
                            )
                    }
                }
                .buttonStyle(
                    .plain
                )


                Spacer()
            }
        }
        .frame(
            height: 64
        )
    }


    // MARK: - Result Card

    private var resultCard:
        some View {

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
            .foregroundStyle(
                .white
            )
            .padding(
                .top,
                20
            )


            timeCounter
                .padding(
                    .top,
                    14
                )


            sectionDivider
                .padding(
                    .top,
                    22
                )


            // Impulse / Planned

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


            rowDivider


            // One time / Subscription

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


            rowDivider


            // Need / Want

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


            sectionDivider


            urgencySection
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .top,
                    20
                )


            reasonField
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .top,
                    28
                )


            lifeExpectancySection
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .top,
                    24
                )


            actionButtons
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .top,
                    46
                )
                .padding(
                    .bottom,
                    20
                )
        }
        .background(
            Color(
                red: 0.105,
                green: 0.105,
                blue: 0.115
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 38,
                style:
                    .continuous
            )
        )
    }


    // MARK: - Time

    private var timeCounter:
        some View {

        Group {

            if viewModel
                .hourlyRate > 0 {

                HStack(
                    alignment:
                        .top,
                    spacing:
                        7
                ) {

                    timeBox(
                        value:
                            viewModel
                            .daysRequired,

                        label:
                            "Day"
                    )


                    timeSeparator


                    timeBox(
                        value:
                            viewModel
                            .hoursRequired,

                        label:
                            "Hours"
                    )


                    timeSeparator


                    timeBox(
                        value:
                            viewModel
                            .minutesRequired,

                        label:
                            "Minutes"
                    )
                }

            } else {

                Text(
                    "Add your hourly rate in Settings"
                )
                .font(
                    .system(
                        size: 14
                    )
                )
                .foregroundStyle(
                    .white
                        .opacity(
                            0.6
                        )
                )
                .padding(
                    .vertical,
                    22
                )
            }
        }
    }


    private func timeBox(
        value: Int,
        label: String
    ) -> some View {

        VStack(
            spacing: 4
        ) {

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
                width: 48,
                height: 48
            )
            .background {

                LinearGradient(
                    colors: [

                        Color(
                            red: 0.66,
                            green: 0.43,
                            blue: 0.53
                        ),

                        Color(
                            red: 0.86,
                            green: 0.35,
                            blue: 0.24
                        )
                    ],

                    startPoint:
                        .bottomLeading,

                    endPoint:
                        .topTrailing
                )
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10,
                    style:
                        .continuous
                )
            )


            Text(
                label
            )
            .font(
                .system(
                    size: 12
                )
            )
            .foregroundStyle(
                .white
                    .opacity(
                        0.85
                    )
            )
        }
    }


    private var timeSeparator:
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
                8
            )
    }


    // MARK: - Dividers

    private var sectionDivider:
        some View {

        Divider()
            .overlay(
                Color.white
                    .opacity(
                        0.20
                    )
            )
            .padding(
                .horizontal,
                20
            )
    }


    private var rowDivider:
        some View {

        Divider()
            .overlay(
                Color.white
                    .opacity(
                        0.07
                    )
            )
            .padding(
                .horizontal,
                20
            )
    }


    // MARK: - Choice Rows

    private func choiceRow(
        leftTitle: String,
        leftSelected: Bool,
        rightTitle: String,
        rightSelected: Bool,
        leftAction:
            @escaping () -> Void,
        rightAction:
            @escaping () -> Void
    ) -> some View {

        HStack(
            spacing: 0
        ) {

            selectionButton(
                title:
                    leftTitle,

                isSelected:
                    leftSelected,

                action:
                    leftAction
            )
            .frame(
                maxWidth:
                    .infinity,

                alignment:
                    .leading
            )


            selectionButton(
                title:
                    rightTitle,

                isSelected:
                    rightSelected,

                action:
                    rightAction
            )
            .frame(
                maxWidth:
                    .infinity,

                alignment:
                    .leading
            )
        }
        .padding(
            .horizontal,
            20
        )
        .frame(
            height: 66
        )
    }


    private func selectionButton(
        title: String,
        isSelected: Bool,
        action:
            @escaping () -> Void
    ) -> some View {

        Button(
            action:
                action
        ) {

            HStack(
                spacing: 14
            ) {

                ZStack {

                    Circle()
                        .stroke(
                            isSelected
                            ? Color(
                                red: 0.55,
                                green: 0.48,
                                blue: 0.86
                            )

                            : Color.white
                                .opacity(
                                    0.22
                                ),

                            lineWidth:
                                2.5
                        )
                        .frame(
                            width: 24,
                            height: 24
                        )


                    if isSelected {

                        Circle()
                            .fill(
                                Color(
                                    red: 0.55,
                                    green: 0.48,
                                    blue: 0.86
                                )
                            )
                            .frame(
                                width: 12,
                                height: 12
                            )
                    }
                }


                Text(
                    title
                )
                .font(
                    .system(
                        size: 17
                    )
                )
                .foregroundStyle(
                    .white
                )
            }
        }
        .buttonStyle(
            .plain
        )
    }


    // MARK: - Urgency

    private var urgencySection:
        some View {

        VStack(
            spacing: 5
        ) {

            HStack {

                Text(
                    "Not Urgent"
                )


                Spacer()


                Text(
                    "Urgent"
                )
            }
            .font(
                .system(
                    size: 14,
                    weight:
                        .semibold
                )
            )
            .foregroundStyle(
                .white
                    .opacity(
                        0.55
                    )
            )


            Slider(
                value:
                    $viewModel
                    .urgency,

                in:
                    0...1
            )
            .tint(
                Color("Color")
            )
        }
    }


    // MARK: - Working Microphone

    private var reasonField:
        some View {

        HStack(
            spacing: 12
        ) {

            TextField(
                "",
                text:
                    $viewModel.reason,

                prompt:
                    Text(
                        "Explain why you want it"
                    )
                    .foregroundStyle(
                        .white
                            .opacity(
                                0.50
                            )
                    ),

                axis:
                    .vertical
            )
            .lineLimit(
                1...4
            )
            .font(
                .system(
                    size: 17
                )
            )
            .foregroundStyle(
                .white
            )


            Button {

                if speechRecognizer
                    .isRecording {

                    speechRecognizer
                        .stopRecording()

                } else {

                    Task {

                        let allowed =
                            await speechRecognizer
                                .requestAuthorization()


                        guard allowed
                        else {
                            return
                        }


                        speechRecognizer
                            .startRecording(
                                existingText:
                                    viewModel
                                    .reason
                            )
                    }
                }

            } label: {

                Image(
                    systemName:
                        speechRecognizer
                            .isRecording

                        ? "stop.fill"

                        : "mic.fill"
                )
                .font(
                    .system(
                        size: 20,
                        weight:
                            .medium
                    )
                )
                .foregroundStyle(

                    speechRecognizer
                        .isRecording

                    ? Color.red

                    : Color.white
                )
                .frame(
                    width: 38,
                    height: 38
                )
            }
            .buttonStyle(
                .plain
            )
        }
        .padding(
            .horizontal,
            24
        )
        .frame(
            minHeight: 82
        )
        .background(
            Color.white
                .opacity(
                    0.08
                )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 30,
                style:
                    .continuous
            )
        )
    }


    // MARK: - Life Expectancy

    private var lifeExpectancySection:
        some View {

        VStack(
            alignment:
                .leading,
            spacing: 10
        ) {

            Text(
                "How long will you use it/ how many times?"
            )
            .font(
                .system(
                    size: 15
                )
            )
            .foregroundStyle(
                .white
                    .opacity(
                        0.68
                    )
            )


            HStack(
                spacing: 16
            ) {

                TextField(
                    "",
                    text:
                        $viewModel
                        .lifeExpectancy,

                    prompt:
                        Text(
                            "Number"
                        )
                        .foregroundStyle(
                            .white
                                .opacity(
                                    0.45
                                )
                        )
                )
                .keyboardType(
                    .decimalPad
                )
                .font(
                    .system(
                        size: 17
                    )
                )
                .foregroundStyle(
                    .white
                )
                .padding(
                    .horizontal,
                    22
                )
                .frame(
                    height: 64
                )
                .background(
                    Color.white
                        .opacity(
                            0.08
                        )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius:
                            28,

                        style:
                            .continuous
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

                        id:
                            \.self
                    ) { unit in

                        Button(
                            unit
                        ) {

                            viewModel
                                .lifeExpectancyUnit =
                                unit
                        }
                    }

                } label: {

                    HStack(
                        spacing: 12
                    ) {

                        Text(
                            viewModel
                                .lifeExpectancyUnit
                        )


                        Image(
                            systemName:
                                "chevron.down"
                        )
                    }
                    .font(
                        .system(
                            size: 16,
                            weight:
                                .medium
                        )
                    )
                    .foregroundStyle(
                        .white
                            .opacity(
                                0.60
                            )
                    )
                    .padding(
                        .horizontal,
                        20
                    )
                    .frame(
                        height: 64
                    )
                    .background(
                        Color.white
                            .opacity(
                                0.08
                            )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:
                                28,

                            style:
                                .continuous
                        )
                    )
                }
            }


            if let text =
                costPerUnitText {

                Text(
                    text
                )
                .font(
                    .system(
                        size: 12,
                        weight:
                            .medium
                    )
                )
                .foregroundStyle(
                    .white
                        .opacity(
                            0.55
                        )
                )
            }
        }
    }


    // MARK: - Actions

    private var actionButtons:
        some View {

        HStack(
            spacing: 10
        ) {

            Button {

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


                withAnimation {

                    showCoolDownPopup =
                        true
                }

            } label: {

                Text(
                    "Save for later"
                )
                .foregroundStyle(
                    .white
                )
                .frame(
                    maxWidth:
                        .infinity
                )
                .frame(
                    height: 46
                )
                .background(
                    Color(
                        red: 0.55,
                        green: 0.48,
                        blue: 0.84
                    )
                )
                .clipShape(
                    Capsule()
                )
            }


            Button {

                didFinishPurchase =
                    true

            } label: {

                Text(
                    "Buy anyway"
                )
                .foregroundStyle(
                    Color(
                        red: 0.55,
                        green: 0.48,
                        blue: 0.84
                    )
                )
                .frame(
                    maxWidth:
                        .infinity
                )
                .frame(
                    height: 46
                )
                .background(
                    Color.white
                        .opacity(
                            0.10
                        )
                )
                .clipShape(
                    Capsule()
                )
            }
        }
        .font(
            .system(
                size: 16,
                weight:
                    .medium
            )
        )
    }


    // MARK: - Popup

    private var coolDownPopup:
        some View {

        ZStack {

            Color.black
                .opacity(
                    0.78
                )
                .ignoresSafeArea()


            VStack(
                spacing: 16
            ) {

                Text(
                    "Saved to your cool-down list"
                )
                .font(
                    .system(
                        size: 17,
                        weight:
                            .semibold
                    )
                )
                .foregroundStyle(
                    .white
                )


                Text(
                    "Come back in 24 hours and decide with a clearer mind."
                )
                .font(
                    .system(
                        size: 14
                    )
                )
                .foregroundStyle(
                    .white
                        .opacity(
                            0.80
                        )
                )
                .multilineTextAlignment(
                    .center
                )


                Button(
                    "Ok!"
                ) {

                    showCoolDownPopup =
                        false

                    goToCooldown =
                        true
                }
                .foregroundStyle(
                    .white
                )
                .frame(
                    maxWidth:
                        .infinity
                )
                .frame(
                    height: 44
                )
                .background(
                    Color("Color")
                )
                .clipShape(
                    Capsule()
                )
            }
            .padding(
                28
            )
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
                    cornerRadius: 28
                )
            )
            .padding(
                .horizontal,
                28
            )
        }
        .zIndex(10)
    }


    // MARK: - Draft

    private func saveDraftIfNeeded() {

        guard
            !didFinishPurchase,
            !didSaveDraft,
            viewModel
                .hasDraftContent
        else {
            return
        }


        draftStore
            .saveDraft(
                from:
                    viewModel
            )


        didSaveDraft =
            true
    }
}
