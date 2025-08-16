import Foundation

final class MockTransactionsService: TransactionsServiceProtocol {
    
    
    private var transactions: [Transaction] = {
        let calendar = Calendar.current
        let now = Date()
        
        let categories: [Category] = [
            Category(id: 1, name: "Получка", emoji: "💵", isIncome: true),
            Category(id: 2, name: "На покушать", emoji: "🍕", isIncome: false),
            Category(id: 3, name: "На собаку", emoji: "🐶", isIncome: false),
            Category(id: 4, name: "Здоровье", emoji: "💊", isIncome: false),
            Category(id: 5, name: "Подарок", emoji: "🎁", isIncome: true)
        ]
        
        let bankAccount = BankAccount(
            id: 0,
            userId: 0,
            name: "Счет",
            balance: Decimal(10000.0),
            currency: "₽",
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let transactions = [
            Transaction(
                id: 0,
                account: bankAccount,
                category: categories[0],
                amount: 80000,
                transactionDate: calendar.date(byAdding: .day, value: -23, to: now) ?? Date(),
                comment: "Зарплата за май",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 1,
                account: bankAccount,
                category: categories[0],
                amount: 82000,
                transactionDate: calendar.date(byAdding: .day, value: 0, to: now) ?? Date(),
                comment: "Зарплата за июнь",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 2,
                account: bankAccount,
                category: categories[1],
                amount: 1230,
                transactionDate: calendar.date(byAdding: .day, value: 0, to: now) ?? Date(),
                comment: "Ужин в ресторане",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 3,
                account: bankAccount,
                category: categories[1],
                amount: 2780,
                transactionDate: calendar.date(byAdding: .day, value: -13, to: now) ?? Date(),
                comment: "Продукты в супермаркете",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 4,
                account: bankAccount,
                category: categories[2],
                amount: 810,
                transactionDate: calendar.date(byAdding: .day, value: 0, to: now) ?? Date(),
                comment: "Корм для собаки",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 5,
                account: bankAccount,
                category: categories[3],
                amount: 1023,
                transactionDate: calendar.date(byAdding: .day, value: -34, to: now) ?? Date(),
                comment: "Лекарства",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 6,
                account: bankAccount,
                category: categories[4],
                amount: 5000,
                transactionDate: calendar.date(byAdding: .day, value: -29, to: now) ?? Date(),
                comment: "От бабушки",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 7,
                account: bankAccount,
                category: categories[4],
                amount: 10000,
                transactionDate: calendar.date(byAdding: .day, value: 0, to: now) ?? Date(),
                comment: "",
                createdAt: Date(),
                updatedAt: Date()
            ),
            Transaction(
                id: 8,
                account: bankAccount,
                category: categories[1],
                amount: 10000,
                transactionDate: calendar.date(byAdding: .day, value: 0, to: now) ?? Date(),
                comment: "",
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
        
        return transactions
    }()
    
    
    
    func getTransactions(from startDate: Date, to endDate: Date) async -> [Transaction] {
        return transactions.filter({$0.transactionDate >= startDate && $0.transactionDate <= endDate})
    }
    
    func create(_ transaction: Transaction) async {
        transactions.append(transaction)
        print(transactions)
    }
    
    func edit(_ transaction: Transaction) async {
        if let index = transactions.firstIndex(where: {$0.id == transaction.id}) {
            transactions[index] = transaction
        }
    }
    
    func remove(id: Int) async {
        transactions.removeAll { $0.id == id }
    }
}
