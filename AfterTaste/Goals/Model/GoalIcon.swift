//
//  GoalIcon.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//


import SwiftUI

struct GoalIconOption: Identifiable {
    let id: String          // SF Symbol name
    let label: String
    let colorHex: String

    var color: Color { Color(hex: colorHex) ?? .purple }
}

extension GoalIconOption {
    static let all: [GoalIconOption] = [
        GoalIconOption(id: "car.fill",           label: "Car",        colorHex: "#8B7CF6"),
        GoalIconOption(id: "bag.fill",           label: "Bag",        colorHex: "#F59E0B"),
        GoalIconOption(id: "house.fill",         label: "House",      colorHex: "#34D399"),
        GoalIconOption(id: "airplane",           label: "Travel",     colorHex: "#60A5FA"),
        GoalIconOption(id: "laptopcomputer",     label: "Laptop",     colorHex: "#F472B6"),
        GoalIconOption(id: "camera.fill",        label: "Camera",     colorHex: "#A78BFA"),
        GoalIconOption(id: "gift.fill",          label: "Gift",       colorHex: "#FB923C"),
        GoalIconOption(id: "graduationcap.fill", label: "Education",  colorHex: "#2DD4BF"),
    ]
}

// MARK: - Hex color helper

extension Color {
    init?(hex: String) {
        var str = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.hasPrefix("#") { str.removeFirst() }
        guard str.count == 6, let value = UInt64(str, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8)  & 0xFF) / 255
        let b = Double(value         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
