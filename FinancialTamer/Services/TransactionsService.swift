import Foundation

final class TransactionsService {
    private var transactions: [Transaction] = []
    
    func getTransactions(from startDate: Date, to endDate: Date) async -> [Transaction] {
        return transactions.filter({$0.transactionDate >= startDate && $0.transactionDate <= endDate})
    }
    
    func create(_ transaction: Transaction) async {
        transactions.append(transaction)
    }
    
    func edit(_ transaction: Transaction) async {
        if let index = transactions.firstIndex(where: {$0.id == transaction.id}) {
            transactions[index] = transaction
        }
    }
    
    func remove(id: Int) async {
        transactions.removeAll { $0.id == id }
    }
}
