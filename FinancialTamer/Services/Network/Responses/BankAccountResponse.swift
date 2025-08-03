import Foundation

struct BankAccountResponse: Decodable {
    let id: Int
    let userId: Int?
    let name: String
    let balance: String
    let currency: String
    let createdAt: String?
    let updatedAt: String?
}

extension BankAccount {
    init(response: BankAccountResponse) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        self.id = response.id
        self.userId = response.userId ?? 0
        self.name = response.name
        self.balance = Decimal(string: response.balance) ?? 0
        self.currency = response.currency
        self.createdAt = dateFormatter.date(from: response.createdAt ?? Date().description) ?? Date()
        self.updatedAt = dateFormatter.date(from: response.createdAt ?? Date().description) ?? Date()
        
    }
}
