import SwiftUI

struct IncomeScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Доходы сегодня")
            TransactionsListView(direction: .income)
        }
    }
}

#Preview {
    IncomeScreen()
}
