//
//  CooldownViewModel.swift
//  AfterTaste
//
//  Created by Feda  on 17/07/2026.
//


import Foundation
import Combine

final class CooldownViewModel: ObservableObject {

    @Published var items: [CooldownItem] = []

    // قواعد الإشارات تُحمّل مرة واحدة من signals.json (الباك اند)
    private let signalRules: [Rule] = SignalLoader.loadSignals()

    init() {
        #if DEBUG
        items = Self.mockItems()
        // احسب نتيجة التحليل للعناصر التجريبية في السجل حتى تظهر مباشرة عند الاختبار
        for index in items.indices where items[index].status == .history {
            items[index].analysisScores = analyzeReflection(items[index].reflectionText)
        }
        #endif
    }

    #if DEBUG
    private static func mockItems() -> [CooldownItem] {
        let now = Date()
        return [
            // Cool down — جاهز للقرار (Decide)
            CooldownItem(itemName: "Elephant Plushie", price: 30, createdAt: now.addingTimeInterval(-3600 * 25), expiresAt: now.addingTimeInterval(-3600), tags: ["Want", "Planned", "One Time"]),
            CooldownItem(itemName: "Coffee Mug", price: 18, createdAt: now.addingTimeInterval(-3600 * 26), expiresAt: now.addingTimeInterval(-1800), tags: ["Want", "One Time", "Not Urgent"]),
            // Cool down — لسا يبرد (واحد ينتهي بعد 5 ثواني، والثاني وقته طويل)
            CooldownItem(itemName: "Phone Case", price: 25, createdAt: now, expiresAt: now.addingTimeInterval(5), tags: ["Need", "One Time"]),
            CooldownItem(itemName: "Desk Lamp", price: 22, createdAt: now, expiresAt: now.addingTimeInterval(3600 * 12), tags: ["Want", "Planned"]),
            // After taste — تم شراؤه، التأمل جاهز بعد 8 ثواني
            CooldownItem(itemName: "Water Bottle", price: 15, createdAt: now.addingTimeInterval(-3600 * 30), expiresAt: now.addingTimeInterval(-3600 * 5), status: .afterTaste, reflectAt: now.addingTimeInterval(8), firstReaction: "I really wanted it after the cooldown.", tags: ["Want", "One Time"]),
            // History — انتهى التأمل
            CooldownItem(itemName: "Notebook Set", price: 12, createdAt: now.addingTimeInterval(-3600 * 60), expiresAt: now.addingTimeInterval(-3600 * 40), status: .history, firstReaction: "It seemed useful for work.", reflectionText: "I regret it, it was too expensive and I rarely use it.", reflectionChoice: .regret, tags: ["Want", "Planned"])
        ]
    }
    #endif

    // MARK: - Add / Remove

    func addItem(
        name: String,
        price: Double,
        cooldownHours: Int = 24,
        tags: [String] = []
    ) {

        let now = Date()

        let item = CooldownItem(
            itemName: name,
            price: price,
            createdAt: now,
            expiresAt: Calendar.current.date(
                byAdding: .hour,
                value: cooldownHours,
                to: now
            )!,
            tags: tags
        )

        items.append(item)
    }

    func removeItem(_ item: CooldownItem) {
        items.removeAll { $0.id == item.id }
    }

    // MARK: - Cool down

    var readyItems: [CooldownItem] {
        items.filter { $0.status == .cooling && $0.isExpired }
    }

    var coolingItems: [CooldownItem] {
        items.filter { $0.status == .cooling && !$0.isExpired }
    }

    func extendCooldown(_ item: CooldownItem, seconds: TimeInterval) {

        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index].expiresAt = Date().addingTimeInterval(seconds)
    }

    // MARK: - After taste

    /// عند الضغط على Buy: ينتقل العنصر لمرحلة After taste ويبدأ عدّاد التأمل.
    func markBought(
        _ item: CooldownItem,
        firstReaction: String,
        reflectAfter seconds: TimeInterval = 15
    ) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index].status = .afterTaste
        items[index].reflectAt = Date().addingTimeInterval(seconds)
        items[index].firstReaction = firstReaction
    }

    var afterTasteReadyItems: [CooldownItem] {
        items.filter { $0.status == .afterTaste && $0.isReflectReady }
    }

    var afterTasteWaitingItems: [CooldownItem] {
        items.filter { $0.status == .afterTaste && !$0.isReflectReady }
    }

    // MARK: - History

    /// عند إنهاء التأمل (Done): يحلّل النص عبر محرّك الإشارات، يخزّن الدرجات، وينقل العنصر للسجل.
    func submitReflection(
        _ item: CooldownItem,
        text: String,
        choice: ReflectionChoice?
    ) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        items[index].reflectionText = text
        items[index].reflectionChoice = choice
        items[index].analysisScores = analyzeReflection(text)
        items[index].status = .history
    }

    var historyItems: [CooldownItem] {
        items.filter { $0.status == .history }
    }

    /// يشغّل الباك اند: نص (عربي/إنجليزي) → مطابقة إشارات → درجات 0-100 لكل بُعد.
    private func analyzeReflection(_ text: String) -> [String: Int] {
        let matches = SignalMatcher.match(text: text, against: signalRules)
        let totals = SignalMatcher.aggregateByCategory(matches)
        return PurchaseProfileScorer.score(from: totals)
    }
}
