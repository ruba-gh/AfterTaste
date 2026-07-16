//
//  OnboardingStart.swift
//  AfterTaste
//
//  Created by Feda  on 16/07/2026.
//
import SwiftUI

struct onboardingStart: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // صورة الغروب فوق (توصل لأعلى حد الشاشة)
                Image("image")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 428, alignment: .top)
                    .clipped()
                    .ignoresSafeArea(edges: .top)

                Spacer(minLength: 96)

                // شعار AFTERTASTE (صورة بدل نص)
                VStack(alignment: .leading, spacing: 24) {
                    Image("aftertaste white")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)

                    // العنوان مع تلوين "Real Cost"
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            Text("See The ")
                                .foregroundColor(.white)

                            Text("Real Cost")
                                .foregroundColor(Color("Color"))
                        }

                        Text("Before You Buy.")
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 30, weight: .bold))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                    Text("AfterTaste shows you the real cost, gives you a pause, and helps you learn what you regret later.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)

                    // زر Start Setup
                    Button(action: {
                        // TODO: انتقال لشاشة Hourly Rate
                    }) {
                        Text("Start Setup")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color("Color"))
                            .cornerRadius(14)
                    }
                    .padding(.top, 8)

                    // زر I'll do it later
                    Button(action: {
                        // TODO: تخطي الـ Onboarding
                    }) {
                        Text("I'll do it later")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    onboardingStart()
}
