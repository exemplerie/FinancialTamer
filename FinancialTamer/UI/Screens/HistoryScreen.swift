import SwiftUI

struct HistoryScreen: View {
    let direction: Direction
    @State private var historyModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(direction: Direction) {
        self.direction = direction
        self.historyModel = HistoryViewModel(direction: direction)
    }

    var body: some View {
        List {
            Section {
                FilterSection
            }
            Section(header: Text("Операции")) {
                OperationsSection
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "doc")
                        .tint(.element)
                }
            }
        }
        .navigationTitle("Моя история")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                })
                {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .tint(.element)
                }
            }
        }
    }
        

    private var FilterSection: some View {
        VStack() {
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
                Text("₽")
            }
        }
        .background(Color.white)
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
                ForEach(historyModel.visibleTransactions, id: \.id) { transaction in
                    TransactionCellView(transaction: transaction)
                                .listRowSeparator(.hidden)
                        }
                    
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryScreen(direction: .outcome)
    }
}
