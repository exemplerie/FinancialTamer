final class FallbackBankAccountsService: BankAccountsServiceProtocol {
    private let primary: BankAccountsServiceProtocol
    private let fallback: BankAccountsServiceProtocol
    private var isUsingFallback = true
        
    init(primary: BankAccountsServiceProtocol = NetworkBankAccountsService(), fallback: BankAccountsServiceProtocol = MockBankAccountsService()) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func getAccount() async throws -> BankAccount {
        if isUsingFallback {
            return try await fallback.getAccount()
        }
        do {
            return try await primary.getAccount()
        } catch {
            isUsingFallback = true
            return try await fallback.getAccount()
        }
    }
    
    func updateAccount(_ account: BankAccount) async throws {
        if isUsingFallback {
            try await fallback.updateAccount(account)
        } else {
            do {
                try await primary.updateAccount(account)
            } catch {
                isUsingFallback = true
                try await fallback.updateAccount(account)
            }
        }
    }
}
