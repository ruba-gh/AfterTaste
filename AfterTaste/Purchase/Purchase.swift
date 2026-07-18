//
//  Purchase.swift
//  AfterTaste
//
//  Created by Assistant on 16/07/2026.
//

//
//  Purchase.swift
//  AfterTaste
//

import SwiftUI

struct Purchase: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var showResult = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Color.black.ignoresSafeArea()

                    Image("image shadow")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: 250)
                        .clipped()
                        .ignoresSafeArea(edges: .top)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer().frame(height: max(220, geometry.size.height * 0.24))

                            Text("To Purchase")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 24)

                            purchaseCard
                                .frame(maxWidth: 370)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 24)

                            Spacer(minLength: 120)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .background(Color.black)
            .navigationDestination(isPresented: $showResult) {
                PurchaseResult(viewModel: viewModel)
            }
        }
    }

    private var purchaseCard: some View {
        VStack(spacing: 0) {
            Text("Enter Item Details")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white.opacity(0.55))
                .padding(.top, 22)
                .padding(.bottom, 18)

            VStack(spacing: 0) {
                TextField("", text: $viewModel.price, prompt: Text("Price").foregroundStyle(.white.opacity(0.25)))
                    .keyboardType(.decimalPad)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .frame(height: 52)

                Divider()
                    .overlay(.white.opacity(0.10))
                    .padding(.horizontal, 18)

                TextField("", text: $viewModel.itemName, prompt: Text("Item Name").foregroundStyle(.white.opacity(0.25)))
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.words)
                    .padding(.horizontal, 18)
                    .frame(height: 52)
            }
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding(.horizontal, 18)

            Button {
                guard viewModel.canAnalyze else { return }
                showResult = true
            } label: {
                Text("Analyze")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color("Color"))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 58)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.11))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

#Preview {
    Purchase(viewModel: PurchaseViewModel())
        .environmentObject(CooldownViewModel())
}
