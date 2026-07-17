//
//  ContentView.swift
//  AfterTaste
//
//  Created by Ruba Alghamdi on 29/01/1448 AH.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var purchaseVM = PurchaseViewModel()
    @State private var selectedTab = 0

    init() {
        let appearance = UITabBarAppearance()

        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.shadowColor =
            UIColor.white.withAlphaComponent(0.15)

        let normalColor = UIColor.white

        let selectedColor =
            UIColor(named: "Color")
            ?? UIColor.systemPurple

        appearance
            .stackedLayoutAppearance
            .normal
            .iconColor = normalColor

        appearance
            .stackedLayoutAppearance
            .normal
            .titleTextAttributes = [
                .foregroundColor: normalColor
            ]

        appearance
            .stackedLayoutAppearance
            .selected
            .iconColor = selectedColor

        appearance
            .stackedLayoutAppearance
            .selected
            .titleTextAttributes = [
                .foregroundColor: selectedColor
            ]

        UITabBar.appearance().standardAppearance =
            appearance

        UITabBar.appearance().scrollEdgeAppearance =
            appearance

        UITabBar.appearance().unselectedItemTintColor =
            normalColor
    }

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: - Cost

            Purchase(viewModel: purchaseVM)
                .tabItem {
                    Image(
                        systemName:
                            "arrow.up.right.and.arrow.down.left"
                    )

                    Text("Cost")
                }
                .tag(0)

            // MARK: - Decisions

            NavigationStack {
                CooldownView()
            }
            .tabItem {
                Image(
                    systemName: "list.clipboard.fill"
                )

                Text("Decisions")
            }
            .tag(1)

            // MARK: - Goals

            NavigationStack {
                PlaceholderScreen(
                    title: "Goals"
                )
            }
            .tabItem {
                Image(systemName: "target")

                Text("Goals")
            }
            .tag(2)

            // MARK: - Settings

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "person.fill")

                Text("Settings")
            }
            .tag(3)
        }
        .tint(Color("Color"))

        // Forces dark mode throughout the entire app
        .preferredColorScheme(.dark)
    }
}

// MARK: - Placeholder Screen

private struct PlaceholderScreen: View {
    let title: String

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Text(title)
                .font(
                    .system(
                        size: 28,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(
            CooldownViewModel()
        )
        .preferredColorScheme(.dark)
}
