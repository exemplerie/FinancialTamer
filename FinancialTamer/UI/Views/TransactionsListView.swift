import SwiftUI

struct TransactionsListView: View {
    let direction: Direction
    @State var transactionModel = TransactionsListViewModel()
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Всего")
                        Spacer()
                        Text(
                            "\(transactionModel.transactionsSum)")
                        Text("RUB")
                    }
                }
                Section(header: Text("Операции")) {
                    if transactionModel.transactions.isEmpty {
                        Text("За данный период транзакций нет")
                    } else {
                        ForEach(transactionModel.transactions, id: \.id) { transaction in
                            TransactionCellView(transaction: transaction)
                        }
                    }
                }
            }
            
        }
        .task {
            await transactionModel.loadTransactions(direction)
        }
    }
}

#Preview {
    TransactionsListView(direction: .outcome)
}
