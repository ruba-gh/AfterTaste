//
//  Setup.swift
//  AfterTaste
//
//  Created by Feda  on 16/07/2026.
//
import SwiftUI

struct Setup: View {
    @State private var hourlyRate = ""
    @State private var showIncomeEstimator = false
    @State private var incomeAmount = ""
    @State private var workHours = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Color.black
                    .ignoresSafeArea()

                Image("image shadow")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 300, alignment: .top)
                    .clipped()
                    .ignoresSafeArea(edges: .top)

                if showIncomeEstimator {
                    incomeEstimatorScreen
                        .frame(width: geometry.size.width, alignment: .topLeading)
                } else {
                    hourlyRateScreen
                        .frame(width: geometry.size.width, alignment: .topLeading)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
        .animation(.easeInOut(duration: 0.25), value: showIncomeEstimator)
    }

    private var hourlyRateScreen: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What’s your time worth?")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("AfterTaste turns every price into hours of your life, so a purchase feels real before you make it.")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.55))
                .lineSpacing(2)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)

            Text("Hourly Rate")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 40)

            amountField(placeholder: "Amount", text: $hourlyRate, trailingText: "0 $")
                .padding(.top, 12)

            Button(action: {
                showIncomeEstimator = true
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

            finishButton
                .padding(.top, 12)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 90)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var incomeEstimatorScreen: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Let’s estimate your hourly income")
                .font(.system(size: 21, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Tell us what you earn and how long you work to see the average value of one work hour.")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.55))
                .lineSpacing(2)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)

            Text("My income is")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 48)

            HStack {
                Text("Monthly")
                    .font(.system(size: 16))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.55))
            }
            .padding(.horizontal, 28)
            .frame(height: 64)
            .background(Color.white.opacity(0.12))
            .cornerRadius(22)
            .padding(.top, 12)

            Text("I receive")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 28)

            amountField(placeholder: "Amount", text: $incomeAmount, trailingText: "0 $")
                .padding(.top, 12)

            Text("For")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 28)

            HStack {
                HStack(spacing: 6) {
                    Text("Hours")
                        .font(.system(size: 16))
                        .foregroundColor(.white)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.55))
                }

                Spacer()

                TextField("8", text: $workHours)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .frame(width: 60)

                Text("hrs")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 28)
            .frame(height: 64)
            .background(Color.white.opacity(0.12))
            .cornerRadius(22)
            .padding(.top, 12)

            Text("Estimation")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 28)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("1 hour of your time")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)

                    Text("based on ~22 working days / months")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                }

                Spacer()

                Text("$23")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .frame(height: 76)
            .background(
                LinearGradient(
                    colors: [Color("Color"), Color(red: 0.88, green: 0.43, blue: 0.30)],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .cornerRadius(22)
            .padding(.top, 12)

            finishButton
                .padding(.top, 24)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 156)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .transition(.opacity)
    }

    private var finishButton: some View {
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
    }

    private func amountField(placeholder: String, text: Binding<String>, trailingText: String) -> some View {
        HStack(spacing: 12) {
            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .foregroundColor(.white)
                .font(.system(size: 16))

            Text(trailingText)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.horizontal, 28)
        .frame(height: 64)
        .background(Color.white.opacity(0.12))
        .cornerRadius(28)
    }
}

#Preview {
    Setup()
}
