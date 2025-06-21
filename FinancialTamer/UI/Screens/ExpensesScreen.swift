import SwiftUI

struct ExpensesScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Расходы сегодня")
            TransactionsListView(direction: .outcome)
        }
    }
}

#Preview {
    ExpensesScreen()
}
