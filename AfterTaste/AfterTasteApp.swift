//
//  AfterTasteApp.swift
//  AfterTaste
//
//  Created by Ruba Alghamdi on 29/01/1448 AH.
//

import SwiftUI

@main
struct AfterTasteApp: App {
    @StateObject private var cooldownViewModel = CooldownViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(cooldownViewModel)
                .preferredColorScheme(.dark)
        }
    }
}

struct RootView: View {
    @AppStorage("didFinishOnboarding") private var didFinishOnboarding = false
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                onboarding()
            } else if didFinishOnboarding {
                ContentView()
            } else {
                OnboardingStart()
            }
        }
        .task {
            // شاشة الشعار (Splash) تظهر ثانيتين ثم ننتقل للأونبوردنق
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation(.easeInOut(duration: 0.3)) {
                showSplash = false
            }
        }
    }
}
