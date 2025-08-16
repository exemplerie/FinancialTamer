import Foundation


final class NetworkTransactionsService: TransactionsServiceProtocol {
    private let client: NetworkClient
    private let dateFormatter: ISO8601DateFormatter
    
    init(client: NetworkClient = NetworkClient()) {
        self.client = client
        self.dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }
    
    
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        do {
            let accountId = try await NetworkBankAccountsService.shared.getAccount().id
            let basePath = "transactions/account/\(accountId)/period"
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            df.timeZone = TimeZone(secondsFromGMT: 0)
            let startStr = df.string(from: startDate)
            let endStr = df.string(from: endDate)
            
            let queryItems = [
                URLQueryItem(name: "startDate", value: startStr),
                URLQueryItem(name: "endDate", value: endStr)
            ]
            var components = URLComponents()
            components.queryItems = queryItems
            
            guard let queryString = components.percentEncodedQuery else {
                throw ServiceErrors.errorUrl
            }
            
            let endpoint = "\(basePath)?\(queryString)"
            
            var fetchedTransactions = try await client.request(
                endpoint: endpoint,
                method: .get,
                responseType: [TransactionResponse].self
            )
            
            return fetchedTransactions.compactMap { Transaction(response: $0) }
            
        } catch {
            throw ServiceErrors.otherError
        }
    }
    
    func create(_ transaction: Transaction) async throws {
        let transactionRequest = TransactionRequest(accountId: transaction.account.id, categoryId: transaction.category.id, amount: "\(transaction.amount)", transactionDate: dateFormatter.string(from: transaction.transactionDate), comment: transaction.comment)
        
        do {
            let transaction = try await client.request(endpoint: "transactions", method: .post, body: transactionRequest, responseType: TransactionCreateResponce.self)
        } catch {
            throw ServiceErrors.otherError
        }
    }
    
    func edit(_ transaction: Transaction) async throws {
        let transactionRequest = TransactionRequest(accountId: transaction.account.id, categoryId: transaction.category.id, amount: "\(transaction.amount)", transactionDate: dateFormatter.string(from: transaction.transactionDate), comment: transaction.comment)
        do {
            let edited = try await client.request(endpoint: "transactions/\(transaction.id)", method: .put, body: transactionRequest, responseType: Transaction.self)
        } catch {
            throw ServiceErrors.otherError
        }
    }
    
    func remove(id: Int) async {
        do {
            let deleted = try await client.request(endpoint: "transactions/\(id)", method: .delete)
        } catch {
            ServiceErrors.otherError
        }
    }
}
