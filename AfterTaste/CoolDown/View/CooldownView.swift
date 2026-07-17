//
//  CooldownView.swift
//  AfterTaste
//
//  Created by Feda on 17/07/2026.
//

import SwiftUI

struct CooldownView: View {
    @StateObject private var viewModel = CooldownViewModel()
    @State private var selectedSubTab: String = "Cool down"
    
    // التبويبات الأربعة الظاهرة في الفيجما بالرأس
    let topTabs = ["Cool down", "After taste", "History", "Drafts"]
    
    var body: some View {
        ZStack {
            // الخلفية الداكنة الكاملة للتطبيق
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. الرأس (العنوان في المنتصف مع الأيقونة اليمنى)
                headerSection
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                
                // 2. قائمة التبويبات الصغيرة (Pills)
                topTabBar
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                
                // 3. محتوى القائمة المفصلة حسب التصميم
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // قسم الـ Decide
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Decide")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            if viewModel.readyItems.isEmpty {
                                Text("Nothing ready for decision")
                                    .font(.system(size: 13))
                                    .foregroundColor(.darkGrayText)
                                    .padding(.horizontal, 4)
                            } else {
                                ForEach(viewModel.readyItems) { item in
                                    FigmaItemCard(item: item, isCooling: false, onRemove: {
                                        viewModel.removeItem(item)
                                    })
                                }
                            }
                        }
                        
                        // قسم الـ Cooling Down
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cooling Down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            if viewModel.coolingItems.isEmpty {
                                Text("No items cooling down")
                                    .font(.system(size: 13))
                                    .foregroundColor(.darkGrayText)
                                    .padding(.horizontal, 4)
                            } else {
                                ForEach(viewModel.coolingItems) { item in
                                    FigmaItemCard(item: item, isCooling: true, onRemove: {
                                        viewModel.removeItem(item)
                                    })
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100) // أمان للـ Bottom Bar
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews المجهزة من الفيجما
    
    private var headerSection: some View {
        HStack {
            Spacer()
            
            Text("Decision")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .offset(x: 12) // موازنة مع الأيقونة اليمنى ليصبح في المنتصف تماماً
            
            Spacer()
            
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
    
    private var topTabBar: some View {
        HStack(spacing: 8) {
            ForEach(topTabs, id: \.self) { tab in
                Text(tab)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(selectedSubTab == tab ? Color.afterTasteButton : Color.afterTasteButton.opacity(0.4))
                    .foregroundColor(selectedSubTab == tab ? .white : .gray)
                    .clipShape(Capsule())
                    .onTapGesture {
                        selectedSubTab = tab
                    }
            }
            Spacer()
        }
    }
}

// MARK: - Figma Item Card Component

struct FigmaItemCard: View {
    let item: CooldownItem
    let isCooling: Bool
    var onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            // اسم العنصر وسعره متطابق مع الفيجما
            Text(item.itemName)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(String(format: "$%.0f", item.price))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)
            
            Spacer()
            
            if isCooling {
                // كبسولة العداد الموقوت البنفسجية الهادئة متطابقة مع التصميم (03:23:55)
                Text(formatRemainingTime(item.remainingTime))
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(Color.afterTasteButton.opacity(0.5))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.afterTastePurple.opacity(0.3), lineWidth: 1)
                    )
            } else {
                // زر Decide باللون البنفسجي المعتمد في التطبيق
                Button(action: {
                    // تفاعل اتخاذ القرار
                }) {
                    Text("Decide")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.afterTastePurple)
                        .cornerRadius(14)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(height: 52)
        .background(Color.afterTasteButton) // نفس لون الـ Button من لوحة الأصول بالفيجما
        .cornerRadius(12)
        .contextMenu {
            Button(role: .destructive, action: onRemove) {
                Label("Remove Item", systemImage: "trash")
            }
        }
    }
    
    // تحويل الوقت لصيغة الـ Digital المعتمدة بالفيجما (HH:MM:SS)
    private func formatRemainingTime(_ time: TimeInterval) -> String {
        if time <= 0 { return "00:00:00" }
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - لوحة الألوان المطابقة للـ Assets المرفقة بالملي
extension Color {
    // اللون البنفسجي للزر الرئيسي (Button 2 / Color)
    static let afterTastePurple = Color(red: 0.58, green: 0.52, blue: 0.82)
    
    // لون خلفية البطاقات والأزرار الغامقة الرمادية (Button)
    static let afterTasteButton = Color(red: 0.16, green: 0.16, blue: 0.18)
    
    // نصوص رمادية داكنة للحالات الفارغة
    static let darkGrayText = Color(red: 0.4, green: 0.4, blue: 0.4)
}

// MARK: - Preview
#Preview {
    CooldownView()
}

// MARK: - Preview
#Preview {
    CooldownView()
}
