import SwiftUI

enum EditMode {
    case editing
    case creating
}

@Observable
class EditTransactionModel {
    var mode: EditMode
    var transactionId: Int
    var transactionDate: Date
    var transactionTime: Date
    var selectedCategory: Category?
    var categories: [Category] = []
    var textSum: String = ""
    var textComment: String = ""
    var categoriesService = FallbackCategoriesService()
    var transactionsService = FallbackTransactionsService()
    var direction: Direction
    
    init(mode: EditMode, direction: Direction, transactionId: Int = Int(Date().timeIntervalSince1970 * 1000)) {
        self.mode = mode
        self.transactionId = transactionId
        self.transactionDate = .now
        self.transactionTime = .now
        self.selectedCategory = nil
        self.direction = direction
    }
    
    func loadCategories() async throws {
        categories = try await categoriesService.getCategories()
    }
    
    func saveTransaction() async throws {
        Task {
            let bankAccount = try await FallbackBankAccountsService().getAccount()
            
            let newTransaction = Transaction(id: transactionId, account: bankAccount, category: selectedCategory!, amount: Decimal(Int(textSum) ?? 0), transactionDate: transactionDate, comment: textComment, createdAt: transactionTime, updatedAt: transactionTime)
            
            switch mode {
                case .editing:
                try await transactionsService.edit(newTransaction)
            case .creating:
                try await transactionsService.create(newTransaction)
            }
            
        }
    }
}

struct AddNewTransactionScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var model: EditTransactionModel
    var onSave: (() -> Void)?
    
    init(mode: EditMode = .creating, direction: Direction, onSave: (() -> Void)? = nil) {
        self.model = EditTransactionModel(mode: mode, direction: direction)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Статья")
                        Spacer()
                        Menu {
                            ForEach(model.categories) { category in
                                Button(category.name) {
                                    model.selectedCategory = category
                                }
                            }
                        } label: {
                            Text(model.selectedCategory?.name ?? "Не выбрано")
                                .tint(.gray)
                            Image(systemName: "chevron.right")
                                .tint(.gray)
                        }
                        
                    }
                    HStack {
                        Text("Сумма")
                        Spacer()
                        TextField("0", text: $model.textSum)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: model.textSum) { newValue in
                                model.textSum = newValue.validatedMoneyInput()
                                
                            }
                        Text("₽")
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.right")
                            .tint(.gray)
                    }
                    HStack {
                        DatePicker("Дата", selection: $model.transactionDate, displayedComponents: .date)
                    }
                    HStack {
                        DatePicker("Время", selection: $model.transactionTime, displayedComponents: .hourAndMinute)
                    }
                    HStack {
                        TextField("Комментарий", text: $model.textComment)
                            .tint(.gray)
                    }
                }
                if model.mode == .editing {
                    Section {
                        Button("Удалить расход") {
                            Task { try await model.transactionsService.remove(id: model.transactionId)
                            }
                        }
                        .tint(Color.red)
                    }
                }
                
            }
            .navigationTitle("Мои Расходы")
            .safeAreaPadding(.top, 10)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .tint(.element)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        Task {
                            do {
                                try await model.saveTransaction()
                                onSave?()
                                dismiss()
                            } catch {
                                print("Ошибка сохранения:", error)
                            }
                        }
                    }
                    .tint(.element)
                }
            }
            .task {
                Task {
                    do {
                        try await model.loadCategories()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
}

#Preview {
    AddNewTransactionScreen(direction: .income)
}


