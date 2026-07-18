//
//  InsightsView.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//

import SwiftUI

// MARK: - Models

struct InsightStat: Identifiable {
    let id = UUID()
    let icon: String
    let value: String
    let label: String
}

struct InsightCategory: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let colorHex: String
    let description: String
    let amount: String
    let progress: Double

    var color: Color { Color(hex: colorHex) ?? .purple }
}

// MARK: - View

struct InsightsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter = "All time"

    let filters = ["All time", "3 Months", "This year"]

    // Mock stats
    let stats: [InsightStat] = [
        InsightStat(icon: "bag",              value: "38",   label: "Items Tracked"),
        InsightStat(icon: "arrow.clockwise",  value: "2",    label: "Recurring items"),
        InsightStat(icon: "clock",            value: "124h", label: "Work Time Spent"),
        InsightStat(icon: "wallet.bifold",    value: "38",   label: "Total spent"),
    ]

    // Mock insight categories
    let categories: [InsightCategory] = [
        InsightCategory(
            icon: "heart.fill",
            title: "Emotional Satisfaction",
            colorHex: "#E87070",
            description: "47% of purchases caused regret",
            amount: "$182 lost due to regret",
            progress: 0.47
        ),
        InsightCategory(
            icon: "tag.fill",
            title: "Value for Money",
            colorHex: "#E8A070",
            description: "53% of purchases regretted",
            amount: "$198 lost from poor value",
            progress: 0.53
        ),
        InsightCategory(
            icon: "bolt.fill",
            title: "Impulse Level",
            colorHex: "#E8904A",
            description: "38% of impulsive buys regretted",
            amount: "$147 lost on impulse purchases",
            progress: 0.38
        ),
        InsightCategory(
            icon: "bag.fill",
            title: "Practical Usefulness",
            colorHex: "#8B7CF6",
            description: "44% of purchases lacked usefulness",
            amount: "$165 lost on impractical items",
            progress: 0.44
        ),
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Header
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 24)

                    // MARK: Subtitle
                    Text("Understand your purchases and improve your decisions.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.75))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)

                    // MARK: Filter Pills
                    filterPills
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)

                    // MARK: Stats Grid
                    statsGrid
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)

                    // MARK: Insight Cards
                    VStack(spacing: 12) {
                        ForEach(categories) { category in
                            InsightCategoryCard(category: category)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
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
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Insights")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)

            Spacer()

            // Spacer to balance the back button
            Color.clear.frame(width: 36, height: 36)
        }
    }

    // MARK: - Filter Pills

    private var filterPills: some View {
        HStack(spacing: 0) {
            ForEach(filters, id: \.self) { filter in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = filter
                    }
                } label: {
                    Text(filter)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(selectedFilter == filter ? .white : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background {
                            if selectedFilter == filter {
                                Capsule()
                                    .fill(Color(red: 89/255, green: 89/255, blue: 95/255))
                                    .padding(2)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .frame(height: 36)
        .background(
            Capsule()
                .fill(Color(red: 28/255, green: 28/255, blue: 30/255))
        )
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4),
            spacing: 12
        ) {
            ForEach(stats) { stat in
                statCard(stat)
            }
        }
    }

    private func statCard(_ stat: InsightStat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: stat.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color("Color"))

            Text(stat.value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            Text(stat.label)
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.white.opacity(0.45))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
    }
}

// MARK: - Insight Category Card

struct InsightCategoryCard: View {
    let category: InsightCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Icon + Title
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(category.color)
                Text(category.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(category.color)
            }

            // Description + Amount
            HStack {
                Text(category.description)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.55))
                Spacer()
                Text(category.amount)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.55))
            }

            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.1))
                        .frame(height: 5)
                    Capsule()
                        .fill(category.color)
                        .frame(width: geo.size.width * category.progress, height: 5)
                }
            }
            .frame(height: 5)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.white.opacity(0.06), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        InsightsView()
    }
    .preferredColorScheme(.dark)
}

