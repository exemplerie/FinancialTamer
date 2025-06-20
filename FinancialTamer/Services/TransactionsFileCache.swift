import Foundation

class TransactionsFileCache {
    private(set) var transactions: [Transaction] = []
    
    func add(_ transaction: Transaction) {
        guard !transactions.contains(where: {$0.id == transaction.id}) else { return }
        transactions.append(transaction)
    }
    
    func remove(_ transaction: Transaction) {
        transactions.removeAll(where: {$0.id == transaction.id})
    }
    
    func save(to fileURL: URL) throws {
        let objects = transactions.map { $0.jsonObject }
        let data = try JSONSerialization.data(withJSONObject: objects, options: [])
        try data.write(to: fileURL)
    }
    
    func load(from fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        let json = try JSONSerialization.jsonObject(with: data)
        
        guard let array = json as? [Any] else {
            return
        }
        transactions = array.compactMap { Transaction.parse(jsonObject: $0) }
    }
}
