import SwiftUI

struct ExpensesScreen: View {
    var body: some View {
        TransactionsListView(direction: .outcome, title: "Расходы сегодня")
    }
}

#Preview {
    ExpensesScreen()
}
