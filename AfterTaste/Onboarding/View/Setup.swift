//
//  Setup.swift
//  AfterTaste
//
//  Created by Feda on 16/07/2026.
//

import SwiftUI

struct Setup: View {

    // MARK: - Onboarding

    @AppStorage("didFinishOnboarding")
    private var didFinishOnboarding = false


    // MARK: - Saved Income Data

    /// Main value used by PurchaseViewModel
    @AppStorage("afterTaste.hourlyRate")
    private var savedHourlyRate: Double = 0

    /// Same key used in Settings
    @AppStorage("afterTaste.incomeAmount")
    private var savedIncomeAmount: Double = 0

    /// Same key used in Settings
    @AppStorage("afterTaste.workValue")
    private var savedWorkValue: Double = 8

    /// Same key used in Settings
    @AppStorage("afterTaste.incomePeriod")
    private var savedIncomePeriodValue: String = "Monthly"

    /// Same key used in Settings
    @AppStorage("afterTaste.workTimeUnit")
    private var savedWorkTimeUnitValue: String = "Hours"

    /// Extra information used by Setup
    @AppStorage("afterTaste.workDaysPerWeek")
    private var savedWorkDaysPerWeek: Double = 5


    // MARK: - Local State

    @State private var hourlyRate: String = ""

    @State private var showIncomeEstimator = false

    @State private var incomeAmount: String = ""

    @State private var workHours: String = "8"

    @State private var workDays: String = "5"

    @State private var selectedIncomeType: IncomeType = .monthly


    // MARK: - Estimated Hourly Rate

    private var estimatedHourlyRate: Double {
        IncomeEstimator.hourlyRate(
            income:
                parsedNumber(incomeAmount)
                ?? 0,

            type:
                selectedIncomeType,

            workHours:
                parsedNumber(workHours)
                ?? 8,

            workDays:
                parsedNumber(workDays)
                ?? 5
        )
    }


    // MARK: - Body

    var body: some View {

        ZStack(alignment: .top) {

            Color.black
                .ignoresSafeArea()

            Image("image shadow")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()
                .ignoresSafeArea(edges: .top)

            if showIncomeEstimator {

                incomeEstimatorScreen

            } else {

                hourlyRateScreen
            }
        }
        .animation(
            .easeInOut(duration: 0.25),
            value: showIncomeEstimator
        )
    }


    // MARK: - Manual Hourly Rate Screen

    private var hourlyRateScreen: some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            Text("What’s your time worth?")
                .font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)

            Text(
                """
                AfterTaste turns every price into hours of your life, so a purchase feels real before you make it.
                """
            )
            .font(
                .system(
                    size: 13,
                    weight: .medium
                )
            )
            .foregroundColor(
                .white.opacity(0.55)
            )
            .lineSpacing(2)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
            .padding(.top, 8)


            Text("Hourly Rate")
                .font(
                    .system(
                        size: 16,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)
                .padding(.top, 28)


            amountField(
                placeholder: "Amount",
                text: $hourlyRate,
                trailingText: "$"
            )
            .padding(.top, 10)


            Button {

                showIncomeEstimator = true

            } label: {

                Text("Estimate it for me")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundColor(
                        Color("Color")
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 44)
                    .background(
                        Color.white.opacity(0.12)
                    )
                    .cornerRadius(22)
            }
            .padding(.top, 35)


            finishButton
                .padding(.top, 20)


            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 110)
    }


    // MARK: - Income Estimator Screen

    private var incomeEstimatorScreen: some View {

        ScrollView(
            .vertical,
            showsIndicators: false
        ) {

            VStack(
                alignment: .leading,
                spacing: 0
            ) {

                Text(
                    "Let’s estimate your hourly income"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)


                Text(
                    """
                    Tell us what you earn and how long you work to see the average value of one work hour.
                    """
                )
                .font(
                    .system(
                        size: 13,
                        weight: .medium
                    )
                )
                .foregroundColor(
                    .white.opacity(0.55)
                )
                .lineSpacing(2)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.top, 8)


                // MARK: Income Type

                Text("My income is")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)
                    .padding(.top, 28)


                Menu {

                    Picker(
                        "",
                        selection: $selectedIncomeType
                    ) {

                        ForEach(
                            IncomeType.allCases,
                            id: \.self
                        ) { type in

                            Text(type.rawValue)
                                .tag(type)
                        }
                    }

                } label: {

                    HStack {

                        Text(
                            selectedIncomeType.rawValue
                        )
                        .font(
                            .system(size: 16)
                        )
                        .foregroundColor(.white)


                        Spacer()


                        Image(
                            systemName:
                                "chevron.down"
                        )
                        .font(
                            .system(
                                size: 13,
                                weight: .semibold
                            )
                        )
                        .foregroundColor(
                            .white.opacity(0.55)
                        )
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(
                        Color.white.opacity(0.12)
                    )
                    .cornerRadius(18)
                }
                .padding(.top, 10)


                // MARK: Income Amount

                Text("I receive")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)
                    .padding(.top, 18)


                amountField(
                    placeholder: "Amount",
                    text: $incomeAmount,
                    trailingText: "$"
                )
                .padding(.top, 10)


                // MARK: Work Hours

                Text(
                    "Working hours per day"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)
                .padding(.top, 18)


                HStack {

                    Spacer()


                    TextField(
                        "8",
                        text: $workHours
                    )
                    .keyboardType(
                        .decimalPad
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .foregroundColor(.white)
                    .font(
                        .system(size: 16)
                    )
                    .frame(width: 60)


                    Text("hrs")
                        .font(
                            .system(size: 16)
                        )
                        .foregroundColor(
                            .white.opacity(0.5)
                        )
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(
                    Color.white.opacity(0.12)
                )
                .cornerRadius(18)
                .padding(.top, 10)


                // MARK: Work Days

                Text(
                    "Working days per week"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)
                .padding(.top, 18)


                HStack {

                    Spacer()


                    TextField(
                        "5",
                        text: $workDays
                    )
                    .keyboardType(
                        .decimalPad
                    )
                    .multilineTextAlignment(
                        .trailing
                    )
                    .foregroundColor(.white)
                    .font(
                        .system(size: 16)
                    )
                    .frame(width: 60)


                    Text("days")
                        .font(
                            .system(size: 16)
                        )
                        .foregroundColor(
                            .white.opacity(0.5)
                        )
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(
                    Color.white.opacity(0.12)
                )
                .cornerRadius(18)
                .padding(.top, 10)


                // MARK: Estimation

                Text("Estimation")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)
                    .padding(.top, 18)


                HStack {

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {

                        Text(
                            "1 hour of your time"
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.white)


                        Text(
                            """
                            based on ~\(Int(((parsedNumber(workDays) ?? 5) * 4.33).rounded())) working days / month
                            """
                        )
                        .font(
                            .system(size: 11)
                        )
                        .foregroundColor(
                            .black.opacity(0.65)
                        )
                    }


                    Spacer()


                    Text(
                        String(
                            format:
                                "$%.2f",
                            estimatedHourlyRate
                        )
                    )
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .frame(height: 72)
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

                        startPoint:
                            .bottomLeading,

                        endPoint:
                            .topTrailing
                    )
                )
                .cornerRadius(18)
                .padding(.top, 10)


                finishButton
                    .padding(.top, 16)


                Spacer()
                    .frame(height: 50)
            }
            .frame(maxWidth: 344)
            .frame(
                maxWidth: .infinity,
                alignment: .top
            )
            .padding(.top, 112)
        }
        .transition(.opacity)
    }


    // MARK: - Finish Button

    private var finishButton: some View {

        Button {

            saveSetupData()

            didFinishOnboarding = true

        } label: {

            Text("Finish Setup")
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .foregroundColor(.white)
                .frame(
                    maxWidth: .infinity
                )
                .frame(height: 48)
                .background(
                    Color("Color")
                )
                .cornerRadius(24)
        }
        .disabled(!canFinish)
        .opacity(
            canFinish
            ? 1
            : 0.5
        )
    }


    // MARK: - Can Finish

    private var canFinish: Bool {

        if showIncomeEstimator {

            return estimatedHourlyRate > 0

        } else {

            return (
                parsedNumber(hourlyRate)
                ?? 0
            ) > 0
        }
    }


    // MARK: - Save Setup Data

    private func saveSetupData() {

        if showIncomeEstimator {

            let income =
                parsedNumber(incomeAmount)
                ?? 0

            let hours =
                parsedNumber(workHours)
                ?? 8

            let days =
                parsedNumber(workDays)
                ?? 5


            // Save original income information
            savedIncomeAmount =
                income

            savedWorkValue =
                hours

            savedWorkDaysPerWeek =
                days

            savedIncomePeriodValue =
                selectedIncomeType.rawValue

            savedWorkTimeUnitValue =
                "Hours"


            // Most important:
            // Save calculated hourly rate
            savedHourlyRate =
                estimatedHourlyRate

        } else {

            // User already knows their
            // hourly rate and entered it manually.

            savedHourlyRate =
                parsedNumber(hourlyRate)
                ?? 0
        }


        print(
            """
            Setup saved:
            Hourly rate = \(savedHourlyRate)
            Income = \(savedIncomeAmount)
            """
        )
    }


    // MARK: - Number Parsing

    private func parsedNumber(
        _ text: String
    ) -> Double? {

        let trimmed =
            text.trimmingCharacters(
                in: .whitespacesAndNewlines
            )


        guard !trimmed.isEmpty
        else {
            return nil
        }


        // Normal number
        if let value =
            Double(trimmed) {

            return value
        }


        guard trimmed.contains(",")
        else {
            return nil
        }


        let groups =
            trimmed.components(
                separatedBy: ","
            )


        let looksLikeThousandsSeparator =
            groups
                .dropFirst()
                .allSatisfy {

                    $0.count == 3 &&

                    $0.allSatisfy(
                        \.isNumber
                    )
                }


        if looksLikeThousandsSeparator {

            return Double(
                trimmed
                    .replacingOccurrences(
                        of: ",",
                        with: ""
                    )
            )

        } else {

            return Double(
                trimmed
                    .replacingOccurrences(
                        of: ",",
                        with: "."
                    )
            )
        }
    }


    // MARK: - Amount Field

    private func amountField(
        placeholder: String,
        text: Binding<String>,
        trailingText: String
    ) -> some View {

        HStack(spacing: 12) {

            TextField(
                placeholder,
                text: text
            )
            .keyboardType(.decimalPad)
            .foregroundColor(.white)
            .font(
                .system(size: 16)
            )


            Spacer()


            Text(trailingText)
                .font(
                    .system(size: 16)
                )
                .foregroundColor(
                    .white.opacity(0.5)
                )
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            Color.white.opacity(0.12)
        )
        .cornerRadius(18)
    }
}


// MARK: - Preview

#Preview {
    Setup()
}
