//
//  Setup.swift
//  AfterTaste
//
//  Created by Feda  on 16/07/2026.
//
import SwiftUI

struct Setup: View {

    @AppStorage("didFinishOnboarding") private var didFinishOnboarding = false

    @State private var hourlyRate: String = ""
    @State private var showIncomeEstimator = false

    @State private var incomeAmount: String = ""
    @State private var workHours: String = "8"
    @State private var workDays: String = "5"
    @State private var selectedIncomeType: IncomeType = .monthly

    private var estimatedHourlyRate: Double {
        IncomeEstimator.hourlyRate(
            income: Double(incomeAmount) ?? 0,
            type: selectedIncomeType,
            workHours: Double(workHours) ?? 8,
            workDays: Double(workDays) ?? 5
        )
    }
    var body: some View  {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()
            
            Image("image shadow")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()
                .ignoresSafeArea(edges: .top)
            
            if showIncomeEstimator {
                incomeEstimatorScreen
            } else {
                hourlyRateScreen
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showIncomeEstimator)
    }
    
    private var hourlyRateScreen: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("What’s your time worth?")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Text("AfterTaste turns every price into hours of your life, so a purchase feels real before you make it.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.55))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)

            Text("Hourly Rate")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 28)

            amountField(
                placeholder: "Amount",
                text: $hourlyRate,
                trailingText: "0 $"
            )
            .padding(.top, 10)

            Button {
                showIncomeEstimator = true
            } label: {
                Text("Estimate it for me")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("Color"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(22)
            }
            .padding(.top, 35)

            finishButton
                .padding(.top, 20)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 110)
    }
    private var incomeEstimatorScreen: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Let’s estimate your hourly income")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text("Tell us what you earn and how long you work to see the average value of one work hour.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.55))
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 312, alignment: .leading)
                .padding(.top, 8)
            
            Text("My income is")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 28)
            
            Menu {
                Picker("", selection: $selectedIncomeType) {
                    ForEach(IncomeType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
            } label: {
                HStack {
                    Text(selectedIncomeType.rawValue)
                        .font(.system(size: 16))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.55))
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color.white.opacity(0.12))
                .cornerRadius(18)
            }
            .padding(.top, 10)
            
            Text("I receive")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 18)
            
            amountField(
                placeholder: "Amount",
                text: $incomeAmount,
                trailingText: "0 $"
            )
            .padding(.top, 10)
            
            Text("Working hours")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 18)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 18)
            
            HStack {
                
                HStack(spacing: 6) {
           
                       
                    
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
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.white.opacity(0.12))
            .cornerRadius(18)
            .padding(.top, 10)
            
            Text("Estimation")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 18)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("1 hour of your time")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("based on ~22 working days / month")
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.65))
                }
                
                Spacer()

                Text(String(format: "$%.0f", estimatedHourlyRate))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .frame(height: 72)
            .background(
                LinearGradient(
                    colors: [
                        Color("Color"),
                        Color(red: 0.88, green: 0.43, blue: 0.30)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .cornerRadius(18)
            .padding(.top, 10)
            
            finishButton
                .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: 344)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 112)
        .transition(.opacity)
        
    }
    private var finishButton: some View {
        Button {
            didFinishOnboarding = true
        } label: {
            Text("Finish Setup")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color("Color"))
                .cornerRadius(24)
        }
    }
    private func amountField(
        placeholder: String,
        text: Binding<String>,
        trailingText: String
    ) -> some View {
        
        HStack(spacing: 12) {
            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .foregroundColor(.white)
                .font(.system(size: 16))
            
            Spacer()
            
            Text(trailingText)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color.white.opacity(0.12))
        .cornerRadius(18)
    }

}

    #Preview {
        Setup()
    }


