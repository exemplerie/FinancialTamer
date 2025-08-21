import Foundation
import SwiftData

@Model
class BankAccountModel {
    @Attribute(.unique) var id: Int
    var userId: Int
    var name: String
    var balance: Decimal
    var currency: String
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \TransactionModel.account)
    var transactions: [TransactionModel] = []

    init(id: Int, userId: Int, name: String, balance: Decimal, currency: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension BankAccount {
    init(model: BankAccountModel) {
        id = model.id
        userId = model.userId
        name = model.name
        balance = model.balance
        currency = model.currency
        createdAt = model.createdAt
        updatedAt = model.updatedAt
    }
}

extension BankAccountModel {
    convenience init(bankAccount: BankAccount) {
        self.init(id: bankAccount.id, userId: bankAccount.userId, name: bankAccount.name, balance: bankAccount.balance, currency: bankAccount.currency, createdAt: bankAccount.createdAt, updatedAt: bankAccount.updatedAt)
    }
}
