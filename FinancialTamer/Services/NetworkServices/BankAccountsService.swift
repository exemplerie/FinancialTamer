import Foundation

final class BankAccountsService {
    private let client: NetworkClient
    
    static let shared = BankAccountsService()

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }
    
    func getAccount() async throws -> BankAccountResponse {
        var accounts = try await client.request(endpoint: "accounts", method: .get, responseType: [BankAccountResponse].self)
        guard let first = accounts.first else {
            throw ServiceErrors.noData
        }
        return first
    }
    
    func createAccount(account: BankAccountRequest) async throws {
        let response = try await client.request(endpoint: "accounts", method: .post, body: account, responseType: BankAccountResponse.self)
    }
    
    func updateAccount(account: BankAccount) async throws {
        let response = try await client.request(endpoint: "accounts/\(account.id)", method: .put, body: account, responseType: BankAccountResponse.self)
    }
}
