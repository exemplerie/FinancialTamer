import SwiftUI

struct TransactionsListView: View {
    let direction: Direction
    let title: String
    @State var transactionModel = TransactionsListViewModel()
    
    init(direction: Direction, title: String) {
        self.direction = direction
        self.title = title
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        HStack {
                            Text("Всего")
                            Spacer()
                            Text(
                                "\(transactionModel.transactionsSum)")
                            Text("₽")
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
                .navigationTitle(title)
                .safeAreaPadding(.top, 10)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            HistoryScreen(direction: .outcome)
                        } label: {
                            Image(systemName: "clock")
                                .tint(.element)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Circle()
                                .frame(width: 60)
                                .foregroundStyle(.accent)
                                .overlay {
                                    Image(systemName: "plus")
                                        .foregroundStyle(Color.white)
                                        .font(.title2)
                                }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
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
    TransactionsListView(direction: .outcome, title: "Доходы сегодня")
}
