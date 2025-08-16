import Foundation

protocol TransactionsServiceProtocol {
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction]
    func create(_ transaction: Transaction) async throws
    func edit(_ transaction: Transaction) async throws
    func remove(id: Int) async throws
}
