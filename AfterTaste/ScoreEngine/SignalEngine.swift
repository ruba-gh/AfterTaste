import Foundation

// MARK: - Model
// نفس اسم زميلتك (Rule/Rules) بس مع إضافة weight

struct Rules: Codable {
    let rules: [Rule]
}

struct Rule: Codable {
    let signal: String
    let category: String
    let keywords: [String]
    let weight: Int
}

struct MatchedSignal {
    let signal: String
    let category: String
    let weight: Int
}

// MARK: - Loading signals.json

enum SignalLoader {
    static func loadSignals() -> [Rule] {
        guard let url = Bundle.main.url(forResource: "signals", withExtension: "json") else {
            print("⚠️ signals.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(Rules.self, from: data)
            return decoded.rules
        } catch {
            print("⚠️ Failed to load signals.json: \(error)")
            return []
        }
    }
}

// MARK: - Arabic text normalization
// يوحد اختلافات الكتابة (تشكيل، همزات، تاء مربوطة) قبل المطابقة

enum ArabicNormalizer {
    static func normalize(_ text: String) -> String {
        var result = text

        // إزالة التشكيل (الحركات)
        let diacritics = "\u{064B}-\u{0652}\u{0670}"
        result = result.replacingOccurrences(
            of: "[\(diacritics)]",
            with: "",
            options: .regularExpression
        )

        // توحيد أشكال الألف والهمزة
        result = result.replacingOccurrences(of: "أ", with: "ا")
        result = result.replacingOccurrences(of: "إ", with: "ا")
        result = result.replacingOccurrences(of: "آ", with: "ا")
        result = result.replacingOccurrences(of: "ٱ", with: "ا")

        // توحيد التاء المربوطة والهاء
        result = result.replacingOccurrences(of: "ة", with: "ه")

        // توحيد الياء والألف المقصورة
        result = result.replacingOccurrences(of: "ى", with: "ي")

        // إزالة علامات الترقيم
        let punctuation = CharacterSet(charactersIn: ".,!؟?؛;:")
        result = result.components(separatedBy: punctuation).joined(separator: " ")

        // إزالة المسافات الزايدة
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        result = result.replacingOccurrences(
            of: " +",
            with: " ",
            options: .regularExpression
        )

        return result.lowercased()
    }
}

// MARK: - Matching engine

enum SignalMatcher {
    /// يفحص النص الحر مقابل قائمة الـ rules ويرجع كل تطابق وجده
    /// يمنع احتساب نفس الـ signal أكثر من مرة (حتى لو تكررت كلماته بنفس الجملة)
    static func match(text: String, against rules: [Rule]) -> [MatchedSignal] {
        let normalizedText = ArabicNormalizer.normalize(text)
        var matches: [MatchedSignal] = []
        var detectedSignals = Set<String>()

        for rule in rules {
            if detectedSignals.contains(rule.signal) {
                continue
            }

            for keyword in rule.keywords {
                let normalizedKeyword = ArabicNormalizer.normalize(keyword)
                if normalizedText.contains(normalizedKeyword) {
                    matches.append(
                        MatchedSignal(
                            signal: rule.signal,
                            category: rule.category,
                            weight: rule.weight
                        )
                    )
                    detectedSignals.insert(rule.signal)
                    break // لقينا كلمة من هذا الـ signal، ننتقل للـ signal التالي
                }
            }
        }

        return matches
    }

    /// يجمع الأوزان حسب الفئة (مفيد لحساب أبعاد الـ Purchase Profile)
    static func aggregateByCategory(_ matches: [MatchedSignal]) -> [String: Int] {
        var totals: [String: Int] = [:]
        for match in matches {
            totals[match.category, default: 0] += match.weight
        }
        return totals
    }
}

// MARK: - Purchase Profile scoring

enum PurchaseProfileScorer {

    /// كل فئة كلمات تابعة لأي بُعد من أبعاد الـ Purchase Profile الأربعة
    /// (Financial Impact ما يجي من هنا، يجي من حساب السعر/الدخل منفصل)
    static let categoryToDimension: [String: String] = [
        "satisfaction": "emotional_satisfaction",
        "regret": "emotional_satisfaction",
        "fading_excitement": "emotional_satisfaction",
        "positive_expectation": "emotional_satisfaction",
        "negative_expectation": "emotional_satisfaction",

        "frequent_use": "practical_usefulness",
        "low_usage": "practical_usefulness",
        "good_quality": "practical_usefulness",
        "poor_quality": "practical_usefulness",

        "impulsive": "impulse_level",
        "planned": "impulse_level",
        "discount_influence": "impulse_level",
        "social_influence": "impulse_level",

        "value_for_money": "value_for_money",
        "financial_concern": "value_for_money",
        "duplicate_purchase": "value_for_money",
    ]

    /// يحول مجموع الأوزان الخام (من aggregateByCategory) إلى سكور 0-100 لكل بُعد
    /// يبدأ كل بُعد من Baseline = 50، ويزيد/ينقص حسب مجموع الأوزان المرتبطة فيه
    static func score(from categoryTotals: [String: Int]) -> [String: Int] {
        var dimensionTotals: [String: Int] = [:]

        // نجمع كل الأوزان اللي تخص نفس البُعد مع بعض
        for (category, weight) in categoryTotals {
            guard let dimension = categoryToDimension[category] else { continue }
            dimensionTotals[dimension, default: 0] += weight
        }

        // نحول كل مجموع لسكور 0-100 بادئ من 50
        var scores: [String: Int] = [:]
        for (dimension, total) in dimensionTotals {
            let raw = 50 + total
            scores[dimension] = min(100, max(0, raw)) // يمنع الرقم يطلع خارج 0-100
        }

        return scores
    }
}
