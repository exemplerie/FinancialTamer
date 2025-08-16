import SwiftUI

@Observable
final class AccountModel {
    var service: BankAccountsServiceProtocol
    var account: BankAccount?
    var isInEditingState: Bool = false
    var isBalanceHidden: Bool = false
    
    
    init(service: BankAccountsServiceProtocol = FallbackBankAccountsService()) {
        self.service = service
        Task { try await loadAccount() }
    }
    
    func loadAccount() async throws {
        self.account = try await service.getAccount()
    }
    
    func getBalance() async -> Decimal {
        return self.account?.balance ?? 0
    }
    
    func getCurrency() async -> String {
        return self.account?.currency ?? "₽"
    }
    
    func getEditingState() -> Bool {
        return self.isInEditingState
    }
    
    func toggleEditState() {
        self.isInEditingState.toggle()
    }
    
    func toggleHiddenState() {
        self.isBalanceHidden.toggle()
    }
    
    func saveChanges(newCurrency: String, newBalance: Decimal) async {
        let currencyChanged = await newCurrency != self.getCurrency()
        let balanceChanged = await newBalance != self.getBalance()
        
        guard currencyChanged || balanceChanged else { return }
        
        if currencyChanged {
            self.account?.currency = newCurrency
        }
        
        if balanceChanged {
            self.account?.balance = newBalance
        }
        
        try? await service.updateAccount(self.account!)
    }
}
