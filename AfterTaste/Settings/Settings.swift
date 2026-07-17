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

    @AppStorage("afterTaste.hourlyRate")
    private var hourlyRate: Double = 0

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text("Your hourly rate")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    TextField(
                        "0",
                        value: $hourlyRate,
                        format:
                            .number
                            .precision(
                                .fractionLength(0...2)
                            )
                    )
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .keyboardType(.decimalPad)

                    Text("SAR / hour")
                        .font(
                            .system(
                                size: 16,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .frame(height: 68)
                .background(
                    Color.primary.opacity(0.06)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )

                Text(
                    """
                    AfterTaste uses this to translate a purchase price into working time.
                    """
                )
                .font(
                    .system(size: 15)
                )
                .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Hourly rate")
        .navigationBarTitleDisplayMode(.inline)
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
