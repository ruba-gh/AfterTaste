//
//  OnboardingStart.swift
//  AfterTaste
//
//  Created by Feda on 16/07/2026.
//

import SwiftUI

struct OnboardingStart: View {

    @AppStorage("didFinishOnboarding")
    private var didFinishOnboarding = false

    var body: some View {
        NavigationStack {

            ZStack {
                // يتغير تلقائيًا بين الأبيض والأسود
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    Image("image")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 428, alignment: .top)
                        .clipped()
                        .ignoresSafeArea(edges: .top)

                    Spacer(minLength: 96)

                    VStack(
                        alignment: .leading,
                        spacing: 24
                    ) {

                        // Logo
                        Image("aftertaste white")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.primary)
                            .scaledToFit()
                            .frame(height: 30)

                        // Title
                        VStack(
                            alignment: .leading,
                            spacing: 2
                        ) {
                            HStack(spacing: 0) {

                                Text("See The ")
                                    .foregroundStyle(.primary)

                                Text("Real Cost")
                                    .foregroundStyle(
                                        Color("Color")
                                    )
                            }

                            Text("Before You Buy.")
                                .foregroundStyle(.primary)
                        }
                        .font(
                            .system(
                                size: 30,
                                weight: .bold
                            )
                        )

                        // Description
                        Text(
                            """
                            AfterTaste shows you the real cost, gives you a pause, and helps you learn what you regret later.
                            """
                        )
                        .font(
                            .system(size: 15)
                        )
                        .foregroundStyle(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )

                        // Start Setup
                        NavigationLink {
                            Setup()
                        } label: {

                            Text("Start Setup")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(.white)
                                .frame(
                                    maxWidth: .infinity
                                )
                                .frame(height: 52)
                                .background(
                                    Color("Color")
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 25,
                                        style: .continuous
                                    )
                                )
                        }
                        .padding(.top, 8)

                        // Skip
                        Button {
                            didFinishOnboarding = true

                        } label: {

                            Text("I'll do it later")
                                .font(
                                    .system(size: 14)
                                )
                                .foregroundStyle(
                                    .color
                                )
                                .frame(
                                    maxWidth: .infinity
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 60)
                }
            }
            .navigationBarHidden(true)
        }
    }
}


// MARK: - Preview

#Preview("Dark") {
    OnboardingStart()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    OnboardingStart()
        .preferredColorScheme(.light)
}
