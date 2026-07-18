//
//  ReflectionAnalysisView.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//

//
//  ReflectionAnalysisView.swift
//  AfterTaste
//

import SwiftUI

struct ReflectionAnalysisView: View {
    let item: CooldownItem
    let initialChoice: ReflectionChoice

    // Reflection text — editable via pencil
    @State private var reflectionText: String
    // The text that produced the current insights (used to detect edits)
    @State private var analyzedText: String

    @State private var insights: [ReflectionInsight]
    @State private var isSaved = false
    @State private var isEditingText = false

    @Environment(\.dismiss) private var dismiss
    @FocusState private var textFocused: Bool

    // Re-analyse button appears only after saving if text was changed
    private var hasUnsavedEdits: Bool {
        isSaved && reflectionText.trimmingCharacters(in: .whitespaces) != analyzedText
    }

    init(item: CooldownItem, reflectionText: String, choice: ReflectionChoice) {
        self.item = item
        self.initialChoice = choice
        let trimmed = reflectionText.trimmingCharacters(in: .whitespaces)
        _reflectionText = State(initialValue: trimmed)
        _analyzedText   = State(initialValue: trimmed)
        _insights       = State(initialValue: ReflectionAnalyzer.analyze(text: trimmed, choice: choice))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Header
                    headerSection
                        .padding(.top, 16)

                    // MARK: Your Reflection Card
                    yourReflectionCard

                    // MARK: From Your Reflection
                    if !insights.isEmpty {
                        Text("From your reflection")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.45))

                        VStack(spacing: 12) {
                            ForEach(insights) { insight in
                                InsightCard(
                                    insight: insight,
                                    showDismiss: !isSaved
                                ) {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        insights.removeAll { $0.id == insight.id }
                                    }
                                }
                            }
                        }
                    }

                    // MARK: Done Button
                    if !isSaved {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isEditingText = false
                                textFocused   = false
                                isSaved       = true
                            }
                        } label: {
                            Text("Done")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color("Color"))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                    }

                    // MARK: Re-analyse Button (only after saving + editing)
                    if hasUnsavedEdits {
                        Button {
                            let trimmed = reflectionText.trimmingCharacters(in: .whitespaces)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                insights     = ReflectionAnalyzer.analyze(text: trimmed, choice: initialChoice)
                                analyzedText = trimmed
                                isSaved      = false
                                isEditingText = false
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 13, weight: .medium))
                                Text("Re-analyse reflection")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundStyle(.white.opacity(0.55))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.10))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Analysis")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            Color.clear.frame(width: 36, height: 36)
        }
    }

    // MARK: - Your Reflection Card

    private var yourReflectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your reflection")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                // Pencil: only show if not editing and not saved, or if saved (to allow re-edit)
                Button {
                    isEditingText.toggle()
                    if isEditingText {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            textFocused = true
                        }
                    } else {
                        textFocused = false
                    }
                } label: {
                    Image(systemName: isEditingText ? "checkmark" : "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.55))
                }
                .buttonStyle(.plain)
            }

            if isEditingText {
                TextEditor(text: $reflectionText)
                    .focused($textFocused)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 80)
                    .tint(Color("Color"))
            } else {
                Text(reflectionText.isEmpty ? "No reflection entered." : "\"\(reflectionText)\"")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.80))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
    }
}

// MARK: - Insight Card

struct InsightCard: View {
    let insight: ReflectionInsight
    let showDismiss: Bool
    let onDismiss: () -> Void

    private var sentimentColor: Color {
        insight.sentiment == .positive ? Color("Color") : Color(red: 0.88, green: 0.43, blue: 0.30)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Title row
            HStack(spacing: 8) {
                Text(insight.category)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Text(insight.sentiment.label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(sentimentColor)

                if showDismiss {
                    Button(action: onDismiss) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.12))
                                .frame(width: 26, height: 26)
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            // Quote
            Text(insight.quote)
                .font(.system(size: 13).italic())
                .foregroundStyle(.white.opacity(0.50))

            // Progress + intensity
            HStack(spacing: 10) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.10))
                            .frame(height: 5)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color("Color"),
                                        Color(red: 0.89, green: 0.44, blue: 0.30)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * insight.progress, height: 5)
                    }
                }
                .frame(height: 5)

                Text(insight.intensity.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(minWidth: 60, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ReflectionAnalysisView(
            item: CooldownItem(itemName: "Elephant Plushie", price: 30, createdAt: .now, expiresAt: .now),
            reflectionText: "I really like it. It wasn't worth the price and I haven't used it a lot but I would buy it again.",
            choice: .happy
        )
    }
    .preferredColorScheme(.dark)
}

