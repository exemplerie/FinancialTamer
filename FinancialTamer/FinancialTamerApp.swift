import SwiftUI
import SwiftData

@main
struct FinancialTamerApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
        .modelContainer(for: [TransactionModel.self, CategoryModel.self, BankAccountModel.self])
    }
}
