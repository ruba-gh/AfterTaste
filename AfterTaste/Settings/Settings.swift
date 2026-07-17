//
//  Settings.swift
//  AfterTaste
//
//  Created by Ruba Alghamdi on 03/02/1448 AH.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {

    @Environment(\.colorScheme) private var colorScheme

    @AppStorage("afterTaste.theme")
    private var selectedTheme: AppTheme = .auto

    @AppStorage("afterTaste.notifications.cooldownEnding")
    private var cooldownEndingNotification = true

    @AppStorage("afterTaste.notifications.reflectionReady")
    private var reflectionReadyNotification = true

    @State private var showDeleteConfirmation = false
    @State private var showExporter = false

    @State private var exportDocument = AfterTasteExportDocument()

    let exportData: () -> Data
    let deleteAllData: () -> Void

    init(
        exportData: @escaping () -> Data = SettingsView.defaultExportData,
        deleteAllData: @escaping () -> Void = {}
    ) {
        self.exportData = exportData
        self.deleteAllData = deleteAllData
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 14
                ) {

                    incomeSection

                    appearanceSection

                    notificationSection

                    privacySection
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            .hidden,
            for: .navigationBar
        )
        .alert(
            "Delete all data?",
            isPresented: $showDeleteConfirmation
        ) {
            Button(
                "Cancel",
                role: .cancel
            ) {}

            Button(
                "Delete",
                role: .destructive
            ) {
                deleteAllData()
            }
        } message: {
            Text(
                """
                This permanently removes your purchases, reflections, goals, and preferences from this device.
                """
            )
        }
        .fileExporter(
            isPresented: $showExporter,
            document: exportDocument,
            contentType: .json,
            defaultFilename: "AfterTaste-Data"
        ) { result in
            switch result {
            case .success:
                print("Data exported successfully")

            case .failure(let error):
                print(
                    "Export failed: \(error.localizedDescription)"
                )
            }
        }
    }

    // MARK: - Income

    private var incomeSection: some View {
        settingsSection(
            title: "Income"
        ) {
            NavigationLink {
                HourlyRateSettingsView()
            } label: {
                SettingsDisclosureRow(
                    title: "Hourly rate"
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        settingsSection(
            title: "Appearance"
        ) {
            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                Text("Theme")
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.primary)

                ThemeSelector(
                    selection: $selectedTheme
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
    }

    // MARK: - Notifications

    private var notificationSection: some View {
        settingsSection(
            title: "Notification"
        ) {
            VStack(spacing: 0) {
                SettingsToggleRow(
                    title: "Cool down ending",
                    isOn: $cooldownEndingNotification
                )

                SettingsDivider()

                SettingsToggleRow(
                    title: "Reflection ready",
                    isOn: $reflectionReadyNotification
                )
            }
        }
    }

    // MARK: - Privacy

    private var privacySection: some View {
        settingsSection(
            title: "Privacy & Data"
        ) {
            VStack(spacing: 0) {

                NavigationLink {
                    DataUsageView()
                } label: {
                    SettingsDisclosureRow(
                        title: "How your data is used"
                    )
                }
                .buttonStyle(.plain)

                SettingsDivider()

                Button {
                    exportDocument =
                        AfterTasteExportDocument(
                            data: exportData()
                        )

                    showExporter = true

                } label: {
                    SettingsDisclosureRow(
                        title: "Export your data"
                    )
                }
                .buttonStyle(.plain)

                SettingsDivider()

                Button(
                    role: .destructive
                ) {
                    showDeleteConfirmation = true

                } label: {
                    HStack(spacing: 12) {
                        Text("Delete all data")
                            .font(
                                .system(size: 17)
                            )
                            .foregroundStyle(.red)

                        Spacer()

                        Image(
                            systemName: "trash"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.red)
                    }
                    .padding(.horizontal, 22)
                    .frame(minHeight: 64)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Section Container

    @ViewBuilder
    private func settingsSection<
        Content: View
    >(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text(title)
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.secondary)
                .padding(.horizontal, 2)

            content()
                .background(cardBackground)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24,
                        style: .continuous
                    )
                )
        }
    }

    private var cardBackground: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.11)
            : Color.black.opacity(0.055)
    }

    // MARK: - Default Export

    private static func defaultExportData() -> Data {
        let exportDate =
            ISO8601DateFormatter()
                .string(from: Date())

        let json = """
        {
          "app": "AfterTaste",
          "exportedAt": "\(exportDate)",
          "purchases": [],
          "goals": [],
          "reflections": []
        }
        """

        return Data(json.utf8)
    }
}

// MARK: - Disclosure Row

private struct SettingsDisclosureRow: View {

    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(
                    .system(size: 17)
                )
                .foregroundStyle(.primary)

            Spacer()

            Image(
                systemName: "chevron.right"
            )
            .font(
                .system(
                    size: 15,
                    weight: .semibold
                )
            )
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 22)
        .frame(minHeight: 64)
        .contentShape(Rectangle())
    }
}

// MARK: - Toggle Row

private struct SettingsToggleRow: View {

    let title: String

    @Binding var isOn: Bool

    var body: some View {
        Toggle(
            isOn: $isOn
        ) {
            Text(title)
                .font(
                    .system(size: 17)
                )
                .foregroundStyle(.primary)
        }
        .tint(Color("Color"))
        .padding(.horizontal, 22)
        .frame(minHeight: 64)
    }
}

// MARK: - Divider

private struct SettingsDivider: View {

    var body: some View {
        Divider()
            .overlay(
                Color.primary.opacity(0.08)
            )
            .padding(.leading, 22)
    }
}

// MARK: - Theme Selector

private struct ThemeSelector: View {

    @Environment(\.colorScheme)
    private var colorScheme

    @Binding var selection: AppTheme

    var body: some View {
        HStack(spacing: 10) {
            ForEach(
                AppTheme.allCases
            ) { theme in

                Button {
                    withAnimation(
                        .easeInOut(duration: 0.18)
                    ) {
                        selection = theme
                    }

                } label: {
                    Text(theme.title)
                        .font(
                            .system(
                                size: 17,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            selection == theme
                                ? Color.white
                                : Color.secondary
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background {
                            Capsule()
                                .fill(
                                    selection == theme
                                        ? Color("Color")
                                        : unselectedBackground
                                )
                        }
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(
                    selection == theme
                        ? .isSelected
                        : []
                )
            }
        }
    }

    private var unselectedBackground: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.07)
            : Color.black.opacity(0.06)
    }
}

// MARK: - Hourly Rate Screen

private struct HourlyRateSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("afterTaste.hourlyRate")
    private var savedHourlyRate: Double = 0

    @AppStorage("afterTaste.incomeAmount")
    private var incomeAmount: Double = 0

    @AppStorage("afterTaste.workValue")
    private var workValue: Double = 8

    @AppStorage("afterTaste.incomePeriod")
    private var incomePeriodValue =
        IncomePeriod.monthly.rawValue

    @AppStorage("afterTaste.workTimeUnit")
    private var workTimeUnitValue =
        WorkTimeUnit.hours.rawValue

    @FocusState private var focusedField: Field?

    private enum Field {
        case amount
        case workValue
    }

    private var incomePeriod: IncomePeriod {
        IncomePeriod(rawValue: incomePeriodValue)
        ?? .monthly
    }

    private var workTimeUnit: WorkTimeUnit {
        WorkTimeUnit(rawValue: workTimeUnitValue)
        ?? .hours
    }

    private var estimatedHourlyRate: Double {
        incomePeriod.hourlyRate(
            income: incomeAmount,
            workValue: workValue,
            unit: workTimeUnit
        )
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 0
                ) {
                    customNavigationBar

                    introSection
                        .padding(.top, 14)

                    incomePeriodSection
                        .padding(.top, 36)

                    incomeAmountSection
                        .padding(.top, 14)

                    workTimeSection
                        .padding(.top, 14)

                    estimationSection
                        .padding(.top, 16)

                    updateButton
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 120)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar(
            .hidden,
            for: .navigationBar
        )
        .toolbar {
            ToolbarItemGroup(
                placement: .keyboard
            ) {
                Spacer()

                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Navigation

    private var customNavigationBar: some View {
        ZStack {
            Text("Income")
                .font(
                    .system(
                        size: 18,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(
                        systemName: "chevron.left"
                    )
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        width: 52,
                        height: 52
                    )
                    .background(
                        Color.white.opacity(0.07)
                    )
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.white.opacity(0.30),
                                lineWidth: 1
                            )
                    }
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .frame(height: 58)
        .padding(.top, 8)
    }

    // MARK: - Introduction

    private var introSection: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text(
                "Let’s estimate your hourly income"
            )
            .font(
                .system(
                    size: 22,
                    weight: .bold
                )
            )
            .foregroundStyle(.white)

            Text(
                """
                Tell us what you earn and how long you work to see the average value of one work hour.
                """
            )
            .font(
                .system(
                    size: 16,
                    weight: .regular
                )
            )
            .foregroundStyle(
                .white.opacity(0.65)
            )
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
    }

    // MARK: - Income Period

    private var incomePeriodSection: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            sectionTitle("My income is")

            Menu {
                ForEach(
                    IncomePeriod.allCases
                ) { period in
                    Button {
                        incomePeriodValue =
                            period.rawValue
                    } label: {
                        if period == incomePeriod {
                            Label(
                                period.title,
                                systemImage: "checkmark"
                            )
                        } else {
                            Text(period.title)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(incomePeriod.title)
                        .font(
                            .system(size: 18)
                        )
                        .foregroundStyle(.white)

                    Spacer()

                    Image(
                        systemName: "chevron.down"
                    )
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(0.55)
                    )
                }
                .padding(.horizontal, 32)
                .frame(height: 74)
                .background(cardColor)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 28,
                        style: .continuous
                    )
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Income Amount

    private var incomeAmountSection: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            sectionTitle("I receive")

            HStack(spacing: 8) {
                Text("Amount")
                    .font(
                        .system(size: 18)
                    )
                    .foregroundStyle(.white)

                Spacer()

                TextField(
                    "0",
                    value: $incomeAmount,
                    format: .number.precision(
                        .fractionLength(0...2)
                    )
                )
                .font(
                    .system(size: 18)
                )
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .focused(
                    $focusedField,
                    equals: .amount
                )
                .frame(maxWidth: 120)

                Text("$")
                    .font(
                        .system(size: 18)
                    )
                    .foregroundStyle(
                        .white.opacity(0.50)
                    )
            }
            .padding(.horizontal, 32)
            .frame(height: 74)
            .background(cardColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )
        }
    }

    // MARK: - Work Time

    private var workTimeSection: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            sectionTitle("For")

            HStack(spacing: 8) {
                Menu {
                    ForEach(
                        WorkTimeUnit.allCases
                    ) { unit in
                        Button {
                            workTimeUnitValue =
                                unit.rawValue
                        } label: {
                            if unit == workTimeUnit {
                                Label(
                                    unit.title,
                                    systemImage: "checkmark"
                                )
                            } else {
                                Text(unit.title)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(workTimeUnit.title)
                            .font(
                                .system(size: 18)
                            )
                            .foregroundStyle(.white)

                        Image(
                            systemName: "chevron.down"
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            .white.opacity(0.55)
                        )
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                TextField(
                    "8",
                    value: $workValue,
                    format: .number.precision(
                        .fractionLength(0...2)
                    )
                )
                .font(
                    .system(size: 18)
                )
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .focused(
                    $focusedField,
                    equals: .workValue
                )
                .frame(maxWidth: 70)

                Text(workTimeUnit.shortTitle)
                    .font(
                        .system(size: 18)
                    )
                    .foregroundStyle(
                        .white.opacity(0.50)
                    )
            }
            .padding(.horizontal, 32)
            .frame(height: 74)
            .background(cardColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )
        }
    }

    // MARK: - Estimation

    private var estimationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle("Estimation")

            HStack(spacing: 14) {
                VStack(
                    alignment: .leading,
                    spacing: 7
                ) {
                    Text("1 hour of your time")
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)

                    Text(calculationDescription)
                        .font(
                            .system(size: 14)
                        )
                        .foregroundStyle(
                            Color.black.opacity(0.75)
                        )
                        .lineLimit(2)
                }

                Spacer()

                Text(
                    estimatedHourlyRate,
                    format: .currency(
                        code: "USD"
                    )
                    .precision(
                        .fractionLength(0)
                    )
                )
                .font(
                    .system(
                        size: 31,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            }
            .padding(.horizontal, 18)
            .frame(height: 88)
            .background {
                LinearGradient(
                    colors: [
                        Color("Color")
                            .opacity(0.95),

                        Color(
                            red: 0.95,
                            green: 0.40,
                            blue: 0.25
                        )
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )
        }
    }

    // MARK: - Update

    private var updateButton: some View {
        Button {
            savedHourlyRate =
                estimatedHourlyRate

            focusedField = nil
            dismiss()
        } label: {
            Text("Update")
                .font(
                    .system(
                        size: 17,
                        weight: .medium
                    )
                )
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Color("Color")
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(
            incomeAmount <= 0 ||
            workValue <= 0
        )
        .opacity(
            incomeAmount > 0 &&
            workValue > 0
                ? 1
                : 0.55
        )
    }

    // MARK: - Helpers

    private func sectionTitle(
        _ title: String
    ) -> some View {
        Text(title)
            .font(
                .system(
                    size: 18,
                    weight: .semibold
                )
            )
            .foregroundStyle(.white)
    }

    private var cardColor: Color {
        Color(
            red: 0.105,
            green: 0.105,
            blue: 0.115
        )
    }

    private var calculationDescription: String {
        switch incomePeriod {
        case .monthly:
            if workTimeUnit == .hours {
                return "based on ~22 working days / month"
            }

            return "based on 8 working hours / day"

        case .weekly:
            if workTimeUnit == .hours {
                return "based on ~5 working days / week"
            }

            return "based on 8 working hours / day"

        case .daily:
            return "based on the entered work time"

        case .project:
            return "based on the total project time"

        case .yearly:
            if workTimeUnit == .hours {
                return "based on ~264 working days / year"
            }

            return "based on 8 working hours / day"
        }
    }
}

// MARK: - Income Period

private enum IncomePeriod:
    String,
    CaseIterable,
    Identifiable {

    case monthly = "Monthly"
    case weekly = "Weekly"
    case daily = "Daily"
    case project = "Per project"
    case yearly = "Yearly"

    var id: String {
        rawValue
    }

    var title: String {
        rawValue
    }

    func hourlyRate(
        income: Double,
        workValue: Double,
        unit: WorkTimeUnit
    ) -> Double {
        guard income > 0,
              workValue > 0
        else {
            return 0
        }

        let dailyHours: Double = 8
        let weeklyWorkingDays: Double = 5
        let monthlyWorkingDays: Double = 22
        let yearlyWorkingDays: Double = 264

        switch self {
        case .monthly:
            switch unit {
            case .hours:
                return income /
                    (
                        monthlyWorkingDays *
                        workValue
                    )

            case .days:
                return income /
                    (
                        workValue *
                        4.33 *
                        dailyHours
                    )
            }

        case .weekly:
            switch unit {
            case .hours:
                return income /
                    (
                        weeklyWorkingDays *
                        workValue
                    )

            case .days:
                return income /
                    (
                        workValue *
                        dailyHours
                    )
            }

        case .daily:
            switch unit {
            case .hours:
                return income / workValue

            case .days:
                return income /
                    (
                        workValue *
                        dailyHours
                    )
            }

        case .project:
            switch unit {
            case .hours:
                return income / workValue

            case .days:
                return income /
                    (
                        workValue *
                        dailyHours
                    )
            }

        case .yearly:
            switch unit {
            case .hours:
                return income /
                    (
                        yearlyWorkingDays *
                        workValue
                    )

            case .days:
                return income /
                    (
                        workValue *
                        52 *
                        dailyHours
                    )
            }
        }
    }
}

// MARK: - Work Time Unit

private enum WorkTimeUnit:
    String,
    CaseIterable,
    Identifiable {

    case hours = "Hours"
    case days = "Days"

    var id: String {
        rawValue
    }

    var title: String {
        rawValue
    }

    var shortTitle: String {
        switch self {
        case .hours:
            return "hrs"

        case .days:
            return "days"
        }
    }
}

// MARK: - Data Usage Screen

private struct DataUsageView: View {

    var body: some View {
        ScrollView(
            .vertical,
            showsIndicators: false
        ) {
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                informationCard(
                    icon: "lock.shield.fill",
                    title: "Stored on your device",
                    text:
                        """
                        Your purchase decisions, goals, and reflections stay on your device unless you choose to export them.
                        """
                )

                informationCard(
                    icon: "text.magnifyingglass",
                    title: "Used for personal insights",
                    text:
                        """
                        AfterTaste uses your entries to calculate cost impact, waiting periods, and reflection insights.
                        """
                )

                informationCard(
                    icon: "square.and.arrow.up",
                    title: "You stay in control",
                    text:
                        """
                        You can export or permanently delete your data at any time from Settings.
                        """
                )
            }
            .padding(24)
        }
        .background(
            Color(uiColor: .systemBackground)
        )
        .navigationTitle(
            "How your data is used"
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    private func informationCard(
        icon: String,
        title: String,
        text: String
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 14
        ) {
            Image(systemName: icon)
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    Color("Color")
                )
                .frame(width: 32)

            VStack(
                alignment: .leading,
                spacing: 7
            ) {
                Text(title)
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.primary)

                Text(text)
                    .font(
                        .system(size: 15)
                    )
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(
            Color.primary.opacity(0.06)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }
}

// MARK: - Export Document

private struct AfterTasteExportDocument:
    FileDocument {

    static var readableContentTypes: [UTType] {
        [.json]
    }

    var data: Data

    init(
        data: Data = Data("{}".utf8)
    ) {
        self.data = data
    }

    init(
        configuration: ReadConfiguration
    ) throws {
        data =
            configuration
                .file
                .regularFileContents
            ?? Data()
    }

    func fileWrapper(
        configuration: WriteConfiguration
    ) throws -> FileWrapper {
        FileWrapper(
            regularFileWithContents: data
        )
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .preferredColorScheme(.dark)
}
