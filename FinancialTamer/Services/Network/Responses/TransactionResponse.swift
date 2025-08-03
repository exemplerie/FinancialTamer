import Foundation

struct TransactionCreateResponce: Decodable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
    let comment: String?
    let createdAt: String
    let updatedAt: String
}

struct TransactionResponse: Decodable {
    let id: Int
    let account: BankAccountResponse
    let category: CategoryResponse
    let amount: String
    let transactionDate: String
    let comment: String?
    let createdAt: String
    let updatedAt: String
}

extension Transaction {
    init(response: TransactionResponse) {
        let isoFormatter = ISO8601DateFormatter()
        
        self.id = response.id
        self.account = .init(response: response.account)
        self.category = .init(response: response.category)
        self.amount = Decimal(string: response.amount) ?? 0
        self.transactionDate = isoFormatter.date(from: response.transactionDate) ?? Date()
        self.comment = response.comment
        self.createdAt = isoFormatter.date(from: response.createdAt) ?? Date()
        self.updatedAt = isoFormatter.date(from: response.updatedAt) ?? Date()
    }
}
