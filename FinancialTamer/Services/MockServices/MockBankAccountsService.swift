import Foundation

final class MockBankAccountsService: BankAccountsServiceProtocol {
    private var mockData = BankAccount(
        id: 1,
        userId: 1,
        name: "Банковский счёт",
        balance: 10000.0,
        currency: "₽",
        createdAt: Date(),
        updatedAt: Date()
    )
    
    func getAccount() async throws -> BankAccount {
        return mockData
    }
    
    func updateAccount(_ account: BankAccount) async throws {
        self.mockData = account
    }
}
