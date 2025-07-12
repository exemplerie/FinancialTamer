import SwiftUI

enum TabMain: String, CaseIterable, Identifiable {
    case expenses
    case income
    case account
    case articles
    case settings
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .expenses: return "expensesIcon"
        case .income: return "incomesIcon"
        case .account: return "accountIcon"
        case .articles: return "articlesIcon"
        case .settings: return "settingsIcon"
        }
    }
    
    var title: String {
        switch self {
        case .expenses: return "Расходы"
        case .income: return "Доходы"
        case .account: return "Счета"
        case .articles: return "Статьи"
        case .settings: return "Настройки"
        }
    }
}

struct MainScreen: View {
    @State var selectedTab: TabMain = .expenses
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabMain.allCases) { tab in
                tabView(for: tab)
                    .tag(tab)
                    .tabItem {
                        VStack {
                            Image(tab.iconName)
                                .renderingMode(.template)
                            Text(tab.title)
                            
                        }
                    }
            }
        }
        .tint(Color.accentColor)
    }
    
    @ViewBuilder
    private func tabView(for tab: TabMain) -> some View {
        switch tab {
        case .expenses:
            ExpensesScreen()
        case .income:
            IncomeScreen()
        case .account:
            AccountScreen()
        case .articles:
            ArticlesScreen()
        case .settings:
            SettingsScreen()
        }
    }
}


struct TabBarButtonConfiguration {
    let icon: String
    let title: String
    let tab: TabMain
}


#Preview {
    MainScreen()
}
