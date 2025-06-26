import SwiftUI

@Observable
final class TransactionsListViewModel: ObservableObject {
    var transactions: [Transaction] = []
    var transactionsSum: Decimal = 0.0
    private let service = TransactionsService()
    
    func loadTransactions(_ direction: Direction) async {
        let calendar  = Calendar.current
        
        let startDay = calendar.startOfDay(for: Date())
        let endDay = calendar.date(byAdding: .day, value: 1, to: startDay) ?? Date()
        
        let dayTransactions = await service.getTransactions(from: startDay, to: endDay)
        let resultTransactions = dayTransactions.filter { $0.category.direction == direction }
                
        await MainActor.run {
            self.transactions = resultTransactions
            self.transactionsSum = resultTransactions.reduce(0) { $0 + $1.amount }
        }
    }
}

