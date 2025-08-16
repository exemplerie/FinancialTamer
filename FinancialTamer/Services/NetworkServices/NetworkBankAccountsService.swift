import Foundation

final class NetworkBankAccountsService: BankAccountsServiceProtocol {
    
    private let client: NetworkClient
    
    static let shared = NetworkBankAccountsService()

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }
    
    func getAccount() async throws -> BankAccount {
        var accounts = try await client.request(endpoint: "accounts", method: .get, responseType: [BankAccountResponse].self)
        guard let first = accounts.first else {
            throw ServiceErrors.noData
        }
        return BankAccount(response: first)
    }
    
    func updateAccount(_ account: BankAccount) async throws {
        let response = try await client.request(endpoint: "accounts/\(account.id)", method: .put, body: account, responseType: BankAccountResponse.self)
    }
}
