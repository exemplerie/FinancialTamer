import SwiftUI

@Observable
final class AccountModel {
    var service: BankAccountsService
    var account: BankAccount?
    var isInEditingState: Bool = false
    var isBalanceHidden: Bool = false
    
    
    init(service: BankAccountsService = BankAccountsService()) {
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
        guard await newCurrency != self.getCurrency() else { return }
        self.account?.currency = newCurrency
        
        guard await newBalance != self.getBalance() else { return }
        self.account?.balance = newBalance
        
        try? await service.updateAccount(self.account!)
    }
}
