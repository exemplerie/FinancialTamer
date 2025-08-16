import SwiftUI

@Observable
final class TransactionsListViewModel: ObservableObject {
    var transactions: [Transaction] = []
    var transactionsSum: Decimal = 0.0
    let service = FallbackTransactionsService()
    
    func loadTransactions(_ direction: Direction) async {
        let calendar  = Calendar.current
        
        let startDay = calendar.startOfDay(for: Date())
        let endDay = calendar.date(byAdding: .day, value: 1, to: startDay) ?? Date()
                
        let resultTransactions = try? await service.getTransactions(from: startDay, to: endDay)
            .filter { $0.category.direction == direction }
                
        await MainActor.run {
            self.transactions = resultTransactions ?? []
            self.transactionsSum = resultTransactions?.reduce(0) { $0 + $1.amount } ?? 0
        }
    }
}

