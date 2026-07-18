//
//  AddGoalSheet.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//


import SwiftUI

struct AddGoalSheet: View {
    @ObservedObject var viewModel: GoalsViewModel
    @FocusState private var focusedField: Field?
    @State private var showIconPicker = false

    enum Field { case name, cost }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 14) {
                    nameAndIconRow
                    if showIconPicker { iconGrid }
                    costField
                    addButton
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showIconPicker)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.resetForm()
                    }
                    .foregroundStyle(.white.opacity(0.6))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    focusedField = .name
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(Color.black)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
    }

    // MARK: - Name + Icon Row

    private var nameAndIconRow: some View {
        HStack(spacing: 10) {
            TextField("", text: $viewModel.newGoalName,
                      prompt: Text("Goal name").foregroundStyle(.white.opacity(0.25)))
                .focused($focusedField, equals: .name)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .tint(Color("Color"))
                .padding(.horizontal, 18)
                .frame(height: 52)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Button {
                withAnimation { showIconPicker.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: viewModel.selectedIcon.id)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(viewModel.selectedIcon.color)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.45))
                        .rotationEffect(.degrees(showIconPicker ? 180 : 0))
                }
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Icon Grid

    private var iconGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4),
            spacing: 10
        ) {
            ForEach(GoalIconOption.all) { option in
                let isSelected = viewModel.selectedIcon.id == option.id
                Button {
                    viewModel.selectedIcon = option
                    withAnimation { showIconPicker = false }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: option.id)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(isSelected ? option.color : .white.opacity(0.4))
                        Text(option.label)
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isSelected ? option.color.opacity(0.15) : Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(isSelected ? option.color.opacity(0.5) : .clear, lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.97, anchor: .top)))
        .padding(.vertical, 4)
    }

    // MARK: - Cost Field

    private var costField: some View {
        HStack {
            TextField("", text: $viewModel.newGoalCost,
                      prompt: Text("Cost").foregroundStyle(.white.opacity(0.25)))
                .focused($focusedField, equals: .cost)
                .keyboardType(.decimalPad)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .tint(Color("Color"))

            Spacer()

            Text("$")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.35))
        }
        .padding(.horizontal, 18)
        .frame(height: 52)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            viewModel.addGoal()
        } label: {
            Text("Add Goal")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    viewModel.isFormValid
                        ? Color("Color")
                        : Color("Color").opacity(0.35)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 38)
        .padding(.top, 6)
        .disabled(!viewModel.isFormValid)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isFormValid)
    }
}

// MARK: - Preview

#Preview {
    AddGoalSheet(viewModel: GoalsViewModel())
        .preferredColorScheme(.dark)
}
