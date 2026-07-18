//
//  ReflectionInsight.swift
//  AfterTaste
//
//  Created by Joud Almashgari on 18/07/2026.
//

import Foundation

// MARK: - Model

struct ReflectionInsight: Identifiable {
    let id: UUID
    var category: String
    var sentiment: InsightSentiment
    var quote: String
    var intensity: InsightIntensity
    var progress: Double

    init(
        id: UUID = UUID(),
        category: String,
        sentiment: InsightSentiment,
        quote: String,
        intensity: InsightIntensity,
        progress: Double
    ) {
        self.id = id
        self.category = category
        self.sentiment = sentiment
        self.quote = quote
        self.intensity = intensity
        self.progress = progress
    }
}

enum InsightSentiment {
    case positive, negative

    var label: String {
        switch self {
        case .positive: return "Positive"
        case .negative: return "Negative"
        }
    }
}

enum InsightIntensity: String {
    case weak     = "Weak"
    case moderate = "Moderate"
    case strong   = "Strong"
}

// MARK: - Dimension Config

private struct DimensionConfig {
    let key: String
    let title: String

    static let all: [DimensionConfig] = [
        DimensionConfig(key: "emotional_satisfaction", title: "Emotional Satisfaction"),
        DimensionConfig(key: "practical_usefulness",   title: "Practical Usefulness"),
        DimensionConfig(key: "impulse_level",          title: "Impulse Level"),
        DimensionConfig(key: "value_for_money",        title: "Value for Money"),
    ]
}

// MARK: - Analyzer (powered by SignalEngine)

struct ReflectionAnalyzer {

    static func analyze(text: String, choice: ReflectionChoice) -> [ReflectionInsight] {
        // 1. Load rules from signals.json
        let rules = SignalLoader.loadSignals()

        // 2. Match the reflection text against all rules
        let matches = SignalMatcher.match(text: text, against: rules)

        // 3. Aggregate matched weights by category
        let categoryTotals = SignalMatcher.aggregateByCategory(matches)

        // 4. Score each dimension (0–100, baseline 50)
        let scores = PurchaseProfileScorer.score(from: categoryTotals)

        // 5. Build one InsightCard per dimension that has a detected signal
        var insights: [ReflectionInsight] = []

        for config in DimensionConfig.all {
            guard let score = scores[config.key] else { continue }

            let sentiment: InsightSentiment = score >= 50 ? .positive : .negative
            let progress  = Double(score) / 100.0
            let distance  = abs(score - 50)
            let intensity: InsightIntensity
            if      distance < 15 { intensity = .weak }
            else if distance < 30 { intensity = .moderate }
            else                  { intensity = .strong }

            // Find categories that feed this dimension
            let relatedCategories = PurchaseProfileScorer.categoryToDimension
                .filter { $0.value == config.key }
                .map    { $0.key }

            // Find which signals matched for this dimension
            let relatedSignals = matches.filter { relatedCategories.contains($0.category) }

            // Extract the most relevant sentence from the user's text
            let quote = extractQuote(for: relatedSignals, from: rules, in: text)
                     ?? defaultQuote(for: config.key, sentiment: sentiment)

            insights.append(ReflectionInsight(
                category:  config.title,
                sentiment: sentiment,
                quote:     "\"\(quote)\"",
                intensity: intensity,
                progress:  progress
            ))
        }

        // 6. Fallback if no signals were detected at all
        return insights.isEmpty ? fallback(for: choice) : insights
    }

    // MARK: - Quote extraction

    /// Splits the text into sentences and returns the first one that contains
    /// a keyword from any of the matched signals for the given dimension.
    private static func extractQuote(
        for signals: [MatchedSignal],
        from rules: [Rule],
        in text: String
    ) -> String? {
        guard !signals.isEmpty else { return nil }

        // Collect all keywords belonging to the matched signals
        let signalNames = Set(signals.map { $0.signal })
        let keywords = rules
            .filter { signalNames.contains($0.signal) }
            .flatMap { $0.keywords }
            .map { ArabicNormalizer.normalize($0) }

        // Split into sentences (handles English periods and Arabic ؟)
        let sentences = text
            .components(separatedBy: CharacterSet(charactersIn: ".!?؟"))
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        return sentences.first { sentence in
            let normalized = ArabicNormalizer.normalize(sentence)
            return keywords.contains { normalized.contains($0) }
        }
    }

    // MARK: - Defaults

    private static func defaultQuote(for dimension: String, sentiment: InsightSentiment) -> String {
        switch dimension {
        case "emotional_satisfaction":
            return sentiment == .positive ? "I'm happy with this purchase." : "I regret this purchase."
        case "practical_usefulness":
            return sentiment == .positive ? "It's been useful in my daily life." : "I haven't used it as much as I expected."
        case "impulse_level":
            return sentiment == .positive ? "This was a planned, deliberate purchase." : "I bought this on impulse."
        case "value_for_money":
            return sentiment == .positive ? "It was worth every penny." : "It wasn't worth the price."
        default:
            return sentiment == .positive ? "I'm satisfied with this purchase." : "I'm not happy with this purchase."
        }
    }

    private static func fallback(for choice: ReflectionChoice) -> [ReflectionInsight] {
        switch choice {
        case .happy:
            return [
                ReflectionInsight(
                    category: "Emotional Satisfaction", sentiment: .positive,
                    quote: "\"I'm happy with this purchase.\"", intensity: .strong, progress: 0.75
                ),
                ReflectionInsight(
                    category: "Value for Money", sentiment: .positive,
                    quote: "\"It was worth it.\"", intensity: .moderate, progress: 0.65
                )
            ]
        case .regret:
            return [
                ReflectionInsight(
                    category: "Emotional Satisfaction", sentiment: .negative,
                    quote: "\"I regret this purchase.\"", intensity: .moderate, progress: 0.35
                ),
                ReflectionInsight(
                    category: "Value for Money", sentiment: .negative,
                    quote: "\"It wasn't worth the price.\"", intensity: .strong, progress: 0.25
                )
            ]
        }
    }
}
