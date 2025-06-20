import Foundation
import XCTest
@testable import FinancialTamer


final class TransactionJSONTests: XCTestCase {
    
    private let transaction = {
        let dateFormatter = ISO8601DateFormatter()
        let transactionDate = dateFormatter.date(from: "2025-06-13T20:30:00Z") ?? Date()
        let createdAt = dateFormatter.date(from: "2025-06-13T15:20:00Z") ?? Date()
        let updatedAt = dateFormatter.date(from: "2025-06-13T17:05:00Z") ?? Date()
        
        let category = Category(id: 2,
                                name: "Здоровье",
                                emoji: "💊",
                                isIncome: false)
        
        let bankAccount = BankAccount(id: 18,
                                      userId: 24,
                                      name: "Счет",
                                      balance: 24000,
                                      currency: "RUB",
                                      createdAt: createdAt,
                                      updatedAt: updatedAt)
        
        let transaction = Transaction(id: 18,
                                      account: bankAccount,
                                      category: category,
                                      amount: 1380,
                                      transactionDate: transactionDate,
                                      comment: "Аптека",
                                      createdAt: createdAt,
                                      updatedAt: updatedAt)
        return transaction
    }()
    
    func testParseValidData() throws {
        let transaction = transaction
        let json = transaction.jsonObject
        
        XCTAssertTrue(JSONSerialization.isValidJSONObject(json), "jsonObject should be valid")
        
        guard let parsedJsonTransaction = Transaction.parse(jsonObject: json) else {
            XCTFail("parse(jsonObject:) returned nil")
            return
        }
        
        XCTAssertEqual(parsedJsonTransaction.id, transaction.id)
        XCTAssertEqual(parsedJsonTransaction.amount, transaction.amount)

        XCTAssertEqual(parsedJsonTransaction.transactionDate, transaction.transactionDate)
        XCTAssertEqual(parsedJsonTransaction.comment, transaction.comment)
        XCTAssertEqual(parsedJsonTransaction.createdAt, transaction.createdAt)
        XCTAssertEqual(parsedJsonTransaction.updatedAt, transaction.updatedAt)
        
        XCTAssertEqual(parsedJsonTransaction.category.id, transaction.category.id)
        XCTAssertEqual(parsedJsonTransaction.category.name, transaction.category.name)
        XCTAssertEqual(parsedJsonTransaction.category.emoji, transaction.category.emoji)
        XCTAssertEqual(parsedJsonTransaction.category.isIncome, transaction.category.isIncome)
        
        XCTAssertEqual(parsedJsonTransaction.account.id, transaction.account.id)
        XCTAssertEqual(parsedJsonTransaction.account.userId, transaction.account.userId)
        XCTAssertEqual(parsedJsonTransaction.account.name, transaction.account.name)
        XCTAssertEqual(parsedJsonTransaction.account.balance, transaction.account.balance)
        XCTAssertEqual(parsedJsonTransaction.account.currency, transaction.account.currency)
        XCTAssertEqual(parsedJsonTransaction.account.createdAt, transaction.account.createdAt)
        XCTAssertEqual(parsedJsonTransaction.account.updatedAt, transaction.account.updatedAt)
    }
    
    func testParseInvalidData() throws {
        let invalid: [String: Any] = ["unexpected": 123]
        let result = Transaction.parse(jsonObject: invalid)
        XCTAssertNil(result, "Parsing invalid JSON object should return nil")
    }
}
