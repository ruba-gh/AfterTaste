import SwiftUI

struct ContentView: View {
    @StateObject private var purchaseVM = PurchaseViewModel()
    @StateObject private var draftStore = DraftStore()

    @State private var selectedTab = 0

    // نفس المفتاح المستخدم في SettingsView
    @AppStorage("afterTaste.theme")
    private var selectedTheme: AppTheme = .auto

    init() {
        let appearance = UITabBarAppearance()

        // استخدمي ألوان النظام عشان تتغير مع Light / Dark
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = UIColor.separator

        let normalColor = UIColor.secondaryLabel

        let selectedColor =
            UIColor(named: "Color")
            ?? UIColor.systemPurple

        appearance
            .stackedLayoutAppearance
            .normal
            .iconColor = normalColor

        appearance
            .stackedLayoutAppearance
            .normal
            .titleTextAttributes = [
                .foregroundColor: normalColor
            ]

        appearance
            .stackedLayoutAppearance
            .selected
            .iconColor = selectedColor

        appearance
            .stackedLayoutAppearance
            .selected
            .titleTextAttributes = [
                .foregroundColor: selectedColor
            ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = normalColor
    }

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: - Cost

            Purchase(viewModel: purchaseVM)
                .tabItem {
                    Image(
                        systemName:
                            "arrow.up.right.and.arrow.down.left"
                    )

                    Text("Cost")
                }
                .tag(0)

            // MARK: - Decisions

            NavigationStack {
                CooldownView()
            }
            .tabItem {
                Image(systemName: "list.clipboard.fill")
                Text("Decisions")
            }
            .tag(1)

            // MARK: - Goals

            NavigationStack {
                GoalsView()
            }
            .tabItem {
                Image(systemName: "target")
                Text("Goals")
            }
            .tag(2)

            // MARK: - Settings

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Settings")
            }
            .tag(3)
        }
        .tint(Color("Color"))

        // أهم تعديل هنا
        .preferredColorScheme(selectedTheme.colorScheme)

        .environmentObject(draftStore)
    }
}


// MARK: - Placeholder Screen

private struct PlaceholderScreen: View {
    let title: String

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            Text(title)
                .font(
                    .system(
                        size: 28,
                        weight: .bold
                    )
                )
                .foregroundStyle(.primary)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Preview

#Preview("App - Default") {
    ContentView()
        .environmentObject(CooldownViewModel())
}

#Preview("Quick Test - Result with running timer") {
    // إعداد ViewModel للاختبار السريع بحيث يشتغل العداد فوراً
    let vm = PurchaseViewModel()
    vm.itemName = "Test Item"
    vm.price = "120"        // سعر المنتج
    vm.hourlyRate = 30      // الراتب بالساعة => الزمن المطلوب = 4 ساعات
    vm.purchaseType = .planned
    vm.paymentType = .oneTime
    vm.purchasePriority = .want

    return NavigationStack {
        PurchaseResult(viewModel: vm)
    }
    .environmentObject(CooldownViewModel())
    .environmentObject(DraftStore())
}
