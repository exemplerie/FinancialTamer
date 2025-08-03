struct TransactionRequest: Codable {
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
    let comment: String?
}
