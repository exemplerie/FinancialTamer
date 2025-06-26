import SwiftUI

struct IncomeScreen: View {
    var body: some View {
        TransactionsListView(direction: .income, title: "Доходы сегодня")
    }
}

#Preview {
    IncomeScreen()
}
