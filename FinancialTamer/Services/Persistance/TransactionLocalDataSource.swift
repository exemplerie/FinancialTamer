import Foundation
import SwiftData

@MainActor
class TransactionLocalDataSource {
    private let container: ModelContainer?
    private let context: ModelContext?
    
    init(container: ModelContainer?, context: ModelContext?) {
        self.container = container
        self.context = context
    }
}

extension TransactionLocalDataSource: TransactionsServiceProtocol {
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        let fetchDescriptor = FetchDescriptor<TransactionModel>(
            predicate: #Predicate { $0.transactionDate >= startDate && $0.transactionDate <= endDate },
            sortBy: [SortDescriptor(\.transactionDate, order: .reverse)]
        )
        
        let fetchedTransactions = try? self.container?.mainContext.fetch(fetchDescriptor)
        let handledTransactions = fetchedTransactions?.compactMap{ Transaction(model: $0) }
        return handledTransactions ?? []
    }
    
    func save(_ transaction: Transaction) {
        let transactionModel = TransactionModel(transaction: transaction)
        self.container?.mainContext.insert(transactionModel)
        try? self.container?.mainContext.save()
    }
    
    func create(_ transaction: Transaction) {
        self.save(transaction)
    }
    
    func edit(_ transaction: Transaction) async throws {
        self.save(transaction)
    }

    func remove(id: Int) {
        let fetchDescriptor = FetchDescriptor<TransactionModel>(
            predicate: #Predicate { $0.id == id }
        )
        if let fetchedTransaction = try? self.container?.mainContext.fetch(fetchDescriptor).first {
            self.container?.mainContext.delete(fetchedTransaction)
            try? self.container?.mainContext.save()
        }
    }
}
