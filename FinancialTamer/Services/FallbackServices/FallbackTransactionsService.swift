import Foundation

final class FallbackTransactionsService: TransactionsServiceProtocol {
    private var primary: TransactionsServiceProtocol
    private var fallback: TransactionsServiceProtocol?
    private var isUsingFallback = true
    
    init(primary: TransactionsServiceProtocol, fallback: TransactionsServiceProtocol) {
        self.primary = primary
        self.fallback = fallback
    }
    
    init() {
        self.primary = NetworkTransactionsService()
        self.fallback = nil
        Task {
            self.fallback = await TransactionLocalDataSource(container: SwiftDataContextManager.shared.container, context: SwiftDataContextManager.shared.context)
        }
    }
    
    func changeDataSource() {
        isUsingFallback.toggle()
    }
    
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        guard let fallback else {
            throw NSError(domain: "Fallback not ready", code: -1)
        }
        
        if isUsingFallback {
            return try await fallback.getTransactions(from: startDate, to: endDate)
        }
        
        do {
            let result = try await primary.getTransactions(from: startDate, to: endDate)
            return result
        } catch {
            isUsingFallback = true
            return try await fallback.getTransactions(from: startDate, to: endDate)
        }
    }
    
    func create(_ transaction: Transaction) async throws {
        guard let fallback else {
            throw NSError(domain: "Fallback not ready", code: -1)
        }
        
        if isUsingFallback {
            try await fallback.create(transaction)
        } else {
            do {
                try await primary.create(transaction)
            } catch {
                isUsingFallback = true
                try await fallback.create(transaction)
            }
        }
    }
    
    func edit(_ transaction: Transaction) async throws {
        guard let fallback else {
            throw NSError(domain: "Fallback not ready", code: -1)
        }
        
        if isUsingFallback {
            try await fallback.edit(transaction)
        } else {
            do {
                try await primary.edit(transaction)
            } catch {
                isUsingFallback = true
                try await fallback.edit(transaction)
            }
        }
    }
    
    func remove(id: Int) async throws {
        guard let fallback else {
            throw NSError(domain: "Fallback not ready", code: -1)
        }
        
        if isUsingFallback {
            try await fallback.remove(id: id)
        } else {
            do {
                try await primary.remove(id: id)
            } catch {
                isUsingFallback = true
                try await fallback.remove(id: id)
            }
        }
    }
}
