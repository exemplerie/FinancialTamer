import Foundation

final class FallbackTransactionsService: TransactionsServiceProtocol {
    private let primary: TransactionsServiceProtocol
    private let fallback: TransactionsServiceProtocol
    private var isUsingFallback = true
    
    init(primary: TransactionsServiceProtocol = NetworkTransactionsService(), fallback: TransactionsServiceProtocol = MockTransactionsService()) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
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
