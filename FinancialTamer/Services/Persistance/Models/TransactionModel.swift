import Foundation
import SwiftData

@Model
class TransactionModel {
    @Attribute(.unique) var id: Int
    
    @Relationship(deleteRule: .nullify)
    var account: BankAccountModel
    
    @Relationship(deleteRule: .nullify)
    var category: CategoryModel
    
    var amount: Decimal
    var transactionDate: Date
    var comment: String?
    var createdAt: Date
    var updatedAt: Date

    init(id: Int, account: BankAccount, category: Category, amount: Decimal, transactionDate: Date, comment: String?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.account = BankAccountModel(bankAccount: account)
        self.category = CategoryModel(category: category)
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension TransactionModel {
    convenience init(transaction: Transaction) {
        self.init(id: transaction.id, account: transaction.account, category: transaction.category, amount: transaction.amount, transactionDate: transaction.transactionDate, comment: transaction.comment, createdAt: transaction.createdAt, updatedAt: transaction.updatedAt)
        print(self.amount)
    }
}

extension Transaction {
    init(model: TransactionModel) {
        id = model.id
        account = BankAccount(model: model.account)
        category = Category(model: model.category)
        amount = model.amount
        transactionDate = model.transactionDate
        comment = model.comment
        createdAt = model.createdAt
        updatedAt = model.updatedAt
    }
}
