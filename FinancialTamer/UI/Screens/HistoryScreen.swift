import SwiftUI

struct HistoryScreen: View {
    let direction: Direction
    @State private var historyModel: HistoryViewModel

    init(direction: Direction) {
        self.direction = direction
        self.historyModel = HistoryViewModel(direction: direction)
    }

    var body: some View {
        VStack(spacing: 15) {
            Text("Моя история")

            FilterSection
            OperationsSection

            Spacer()
        }
        .padding(10)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "doc")
                }
            }
        }
    }

    private var FilterSection: some View {
        VStack(spacing: 15) {
            DatePicker("Начало", selection: $historyModel.startDate, displayedComponents: .date)
            DatePicker("Конец",   selection: $historyModel.endDate,   displayedComponents: .date)

            Menu {
                ForEach(SortOption.allCases) { option in
                    Button(option.rawValue) {
                        historyModel.selectedSort = option
                    }
                }
            } label: {
                Label("Сортировка: \(historyModel.selectedSort.rawValue)", systemImage: "arrow.up.arrow.down")
                    .font(.subheadline)
            }

            HStack {
                Text("Сумма")
                Spacer()
                Text("\(historyModel.totalAmount)")
                Text("RUB")
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal, 5)
    }

    private var OperationsSection: some View {
        Group {
            if historyModel.visibleTransactions.isEmpty {
                VStack {
                    Text("За данный период транзакций нет")
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
            } else {
                List {
                    Section("Операции") {
                        ForEach(historyModel.visibleTransactions, id: \.id) { transaction in
                            TransactionCellView(transaction: transaction)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .cornerRadius(15)
                .padding(.horizontal, 5)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryScreen(direction: .outcome)
    }
}
