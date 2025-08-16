import Foundation

protocol BankAccountsServiceProtocol {
    func getAccount() async throws -> BankAccount
    func updateAccount(_ account: BankAccount) async throws
}
