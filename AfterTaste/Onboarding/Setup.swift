//
//  Setup.swift
//  AfterTaste
//
//  Created by Feda  on 16/07/2026.
//
import SwiftUI

struct Setup: View {
    @State private var hourlyRate = ""

    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()

            Image("image")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 428, alignment: .top)
                .clipped()
                .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 0) {
                Text("What’s your time worth?")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text("AfterTaste turns every price into hours of your life, so a purchase feels real before you make it.")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.55))
                    .lineSpacing(2)
                    .padding(.top, 10)

                Text("Hourly Rate")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                HStack(spacing: 12) {
                    TextField("Amount", text: $hourlyRate)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.white)
                        .font(.system(size: 16))

                    Text("0 $")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.horizontal, 28)
                .frame(height: 64)
                .background(Color.white.opacity(0.12))
                .cornerRadius(28)
                .padding(.top, 12)

                Button(action: {
                    // TODO: Estimate hourly rate from income details.
                }) {
                    Text("Estimate it for me")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("Color"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(22)
                }
                .padding(.top, 38)

                Button(action: {
                    // TODO: Complete onboarding setup.
                }) {
                    Text("Finish Setup")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color("Color"))
                        .cornerRadius(22)
                }
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 90)
        }
    }
}

#Preview {
    Setup()
}
