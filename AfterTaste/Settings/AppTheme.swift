//
//  AppTheme.swift
//  AfterTaste
//
//  Created by Ruba Alghamdi on 03/02/1448 AH.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light
    case dark
    case auto

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .light:
            return "Light"

        case .dark:
            return "Dark"

        case .auto:
            return "Auto"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark

        case .auto:
            return nil
        }
    }
}
