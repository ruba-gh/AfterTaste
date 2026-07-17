//
//  CooldownView.swift
//  AfterTaste
//
//  Created by Feda on 17/07/2026.
//

import SwiftUI

struct CooldownView: View {
    @StateObject private var viewModel = CooldownViewModel()
    @State private var selectedTab: Tab = .coolingDown
    
    enum Tab {
        case coolingDown
        case readyToDecide
    }
    
    var body: some View {
        ZStack {
            // Background matching forced Dark Mode
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Header
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                
                // 2. Custom Tabs
                segmentedTabs
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                // 3. Main Content List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        let activeItems = selectedTab == .coolingDown ? viewModel.coolingItems : viewModel.readyItems
                        
                        if activeItems.isEmpty {
                            emptyStateView
                                .padding(.top, 60)
                        } else {
                            ForEach(activeItems) { item in
                                ItemCard(item: item, tab: selectedTab, onRemove: {
                                    viewModel.removeItem(item)
                                })
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Padding for bottom nav safety
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Cooldown")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Think twice before you spend")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            Spacer()
            
            // Subtle mock profile or action button to anchor the header right side
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
    }
    
    private var segmentedTabs: some View {
        HStack(spacing: 0) {
            tabButton(title: "Cooling Down", count: viewModel.coolingItems.count, isActive: selectedTab == .coolingDown) {
                selectedTab = .coolingDown
            }
            
            tabButton(title: "Ready to Decide", count: viewModel.readyItems.count, isActive: selectedTab == .readyToDecide) {
                selectedTab = .readyToDecide
            }
        }
        .padding(4)
        .background(Color(.systemGray6).opacity(0.6))
        .cornerRadius(12)
    }
    
    private func tabButton(title: String, count: Int, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: isActive ? .semibold : .medium))
                
                Text("\(count)")
                    .font(.system(size: 11, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isActive ? Color.white.opacity(0.2) : Color.gray.opacity(0.2))
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinite)
            .frame(height: 36)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isActive ? Color(.systemGray4).opacity(0.4) : Color.clear)
            )
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: selectedTab)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: selectedTab == .coolingDown ? "flame" : "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.6))
            Text(selectedTab == .coolingDown ? "No items cooling down" : "Nothing ready for decision")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Item Card Component

struct ItemCard: View {
    let item: CooldownItem
    let tab: CooldownView.Tab
    var onRemove: () -> Void
    
    private var gradientColors: [Color] {
        if tab == .coolingDown {
            return [Color.blue, Color.purple]
        } else {
            return [Color.green, Color.emerald]
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Left Status Visual Anchor
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 4, height: 48)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.itemName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(String(format: "$%.2f", item.price))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if tab == .coolingDown {
                // Countdown Capsule
                HStack(spacing: 4) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 11))
                    
                    // استخدام التايمر الديناميكي من الموديل حقك
                    Text(item.remainingTimeFormatted)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .foregroundColor(.orange)
                .background(Color.orange.opacity(0.12))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            } else {
                Button(action: {
                    // Handle decision logic
                }) {
                    Text("Decide")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                }
            }
        }
        .padding(.all, 16)
        .background(Color(.systemGray6).opacity(0.4))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .contextMenu {
            Button(role: .destructive, action: onRemove) {
                Label("Remove Item", systemName: "trash")
            }
        }
    }
}

// Global scope extensions
extension Color {
    static let emerald = Color(red: 0.04, green: 0.73, blue: 0.45)
}

// MARK: - Preview
#Preview {
    CooldownView()
}
