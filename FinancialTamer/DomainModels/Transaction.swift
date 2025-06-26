import Foundation

struct Transaction: Codable {
    let id: Int
    let account: BankAccount
    let category: Category
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    let createdAt: Date
    let updatedAt: Date
}

extension Transaction {
    static func parse(jsonObject: Any) -> Transaction? {
        do {
            guard JSONSerialization.isValidJSONObject(jsonObject) else { return nil }
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try? decoder.decode(Transaction.self, from: data)
        }
        catch {
            return nil
        }
    }
    
    var jsonObject: Any {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            return NSDictionary()
        }
    }
}

extension Transaction {
    static func parseCSV(from csv: String) -> [Transaction]? {
        let isoFormatter = ISO8601DateFormatter()
        
        let rows = csv.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard rows.count > 1 else { return nil }
        
        var transactions: [Transaction] = []
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",")
            guard columns.count == 15 else { continue }
            
            guard let id = Int(columns[0]),
                  let accountId = Int(columns[1]),
                  let balance = Decimal(string: columns[3]),
                  let categoryId = Int(columns[5]),
                  let emoji = columns[7].first,
                  let isIncome = Bool(columns[8]),
                  let amount = Decimal(string: columns[9]),
                  let transactionDate = isoFormatter.date(from: columns[10]),
                  let createdAt = isoFormatter.date(from: columns[12]),
                  let updatedAt = isoFormatter.date(from: columns[13]),
                  let userId = Int(columns[14])
            else {
                return nil
            }
            
            let name = columns[2]
            let currency = columns[4]
            let categoryName = columns[6]
            let comment = columns[11].isEmpty ? nil : columns[11]
            
            let account = BankAccount(
                id: accountId,
                userId: userId,
                name: name,
                balance: balance,
                currency: currency,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
            
            let category = Category(
                id: categoryId,
                name: categoryName,
                emoji: emoji,
                isIncome: isIncome)
            
            let transaction = Transaction(
                id: id,
                account: account,
                category: category,
                amount: amount,
                transactionDate: transactionDate,
                comment: comment,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
            transactions.append(transaction)
        }
        return transactions
    }
}
