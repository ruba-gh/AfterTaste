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

    var body: some View {
        if didFinishOnboarding {
            ContentView()
        } else {
            OnboardingStart()
        }
    }
}
