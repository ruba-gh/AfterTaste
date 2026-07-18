//
//  CooldownItem.swift
//  AfterTaste
//
//  Created by Feda  on 17/07/2026.
//


import Foundation

// مراحل حياة العنصر عبر التطبيق
enum CooldownStatus {
    case cooling      // في فترة التهدئة أو جاهز للقرار (Cool down)
    case afterTaste   // تم شراؤه، بانتظار/جاهز للتأمل (After taste)
    case history      // انتهى التأمل وانتقل للسجل (History)
}

struct CooldownItem: Identifiable {

    let id = UUID()
    let itemName: String
    let price: Double
    let createdAt: Date

    var expiresAt: Date

    var status: CooldownStatus = .cooling

    // بعد الشراء (After taste): متى يصير التأمل متاحاً + الانطباع الأول
    var reflectAt: Date? = nil
    var firstReaction: String = ""

    // بعد الاستخدام (History): نص التأمل + الشعور
    var reflectionText: String = ""
    var reflectionChoice: ReflectionChoice? = nil

    // نتيجة تحليل التأمل عبر محرّك الإشارات — درجات (0-100) لكل بُعد، تُحسب عند إرسال التأمل
    var analysisScores: [String: Int]? = nil

    // وسوم من تحليل الشراء (Want / Planned / One Time / Not Urgent)
    var tags: [String] = []

    // MARK: - Cool down

    var isExpired: Bool {
        Date() >= expiresAt
    }

    var remainingTime: TimeInterval {
        max(0, expiresAt.timeIntervalSinceNow)
    }

    // MARK: - After taste

    var isReflectReady: Bool {
        guard let reflectAt else { return false }
        return Date() >= reflectAt
    }

    var reflectRemaining: TimeInterval {
        guard let reflectAt else { return 0 }
        return max(0, reflectAt.timeIntervalSinceNow)
    }

    // MARK: - Display

    /// نص "Waited …" بناءً على طول فترة التهدئة (من الإنشاء حتى انتهاء التهدئة)
    var waitedText: String {
        let seconds = max(0, Int(expiresAt.timeIntervalSince(createdAt)))
        let minutes = seconds / 60
        if minutes < 60 { return "Waited \(max(1, minutes)) min" }
        let hours = minutes / 60
        if hours < 24 { return "Waited \(hours) h" }
        return "Waited \(hours / 24) d"
    }
}
