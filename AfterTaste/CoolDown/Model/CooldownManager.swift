//
//  CooldownManager.swift
//  AfterTaste
//
//  Created by Feda  on 17/07/2026.
//


import Foundation

struct CooldownManager {

    static func formattedTime(from interval: TimeInterval) -> String {

        let total = Int(interval)

        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60

        return String(
            format: "%02d:%02d:%02d",
            hours,
            minutes,
            seconds
        )
    }
}