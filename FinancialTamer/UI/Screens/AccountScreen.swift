import SwiftUI

struct AccountScreen: View {
    @State var accountModel = AccountModel()
    @State private var showCurrencyPicker = false
    @State var currentVisibleCurrency: String
    @State var currentVisibleBalance: Decimal
    @FocusState private var balanceFocused: Bool
    @State private var balanceText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    BalanceView
                }
                Section {
                    CurrencyView
                }
            }
            .gesture(
                DragGesture().onChanged { _ in
                    UIApplication.shared.endEditing()
                }
            )
            .navigationTitle("Мой Счет")
            .safeAreaPadding(.top, 10)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if accountModel.isInEditingState {
                            if !balanceText.isEmpty {
                                currentVisibleBalance = Decimal(string: balanceText) ?? currentVisibleBalance
                            }
                            balanceFocused = false
                            Task {
                                await accountModel.saveChanges(newCurrency: currentVisibleCurrency, newBalance: currentVisibleBalance)
                            }
                        }
                        accountModel.toggleEditState()
                    } label: {
                        Text(accountModel.getEditingState() ? "Сохранить" : "Редактировать")
                            .tint(.element)
                    }
                }
            }
            .confirmationDialog(
                "Валюта",
                isPresented: $showCurrencyPicker,
                titleVisibility: .visible
            ) {
                Button(
                    "Российский рубль ₽"
                ) {
                    guard currentVisibleCurrency != "₽" else { return }
                    currentVisibleCurrency = "₽"
                }
                Button(
                    "Американский доллар $"
                ) {
                    guard currentVisibleCurrency != "$" else { return }
                    currentVisibleCurrency = "$"
                }
                Button(
                    "Евро €"
                ) {
                    guard currentVisibleCurrency != "€" else { return }
                    currentVisibleCurrency = "€"
                }
            }
            .refreshable {
                try? await accountModel.loadAccount()
            }
        }
    }
    
    private var BalanceView: some View {
        HStack {
            Text("💰")
            Text("Баланс:")
            Spacer()
            if accountModel.isInEditingState {
                TextField("Баланс", text: $balanceText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .focused($balanceFocused)
                    .onChange(of: balanceText) { newValue in
                        balanceText = filterBalanceInput(newValue)
                    }
                    .onChange(of: balanceFocused) {
                        if !balanceFocused {
                            if !balanceText.isEmpty {
                                currentVisibleBalance = Decimal(string: balanceText) ?? currentVisibleBalance
                            }
                        }
                    }
                
            } else {
                Text("\(currentVisibleBalance)")
                    .spoiler(isOn: $accountModel.isBalanceHidden)
            }
            ShakeDetector {
                withAnimation {
                    accountModel.toggleHiddenState()
                }
            }
            .frame(width: 0, height: 0)
        }.task {
            await loadAccountData()
        }
    }
    
    private func filterBalanceInput(_ input: String) -> String {
        let allowed = "0123456789.,"
        var filtered = input.filter { allowed.contains($0) }
        filtered = filtered.replacingOccurrences(of: ",", with: ".")
        let parts = filtered.split(separator: ".", omittingEmptySubsequences: false)
        if parts.count > 1 {
            filtered = parts[0] + "." + parts[1...].joined()
        }
        return filtered
    }
    
    private var CurrencyView: some View {
        HStack {
            Text("Валюта")
            Spacer()
            Group {
                Text("\(currentVisibleCurrency)")
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
            }.foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if accountModel.isInEditingState {
                showCurrencyPicker = true
            }
        }.task {
            await loadAccountData()
        }
    }
    
    func loadAccountData() async {
        currentVisibleCurrency = await accountModel.getCurrency()
        let balance = await accountModel.getBalance()
        currentVisibleBalance = balance
    }
    
    init(accountModel: AccountModel = AccountModel(), showCurrencyPicker: Bool = false, currentVisibleCurrency: String = "₽", currentVisibleBalance: Decimal = 0) {
        self.accountModel = accountModel
        self.showCurrencyPicker = showCurrencyPicker
        self.currentVisibleCurrency = currentVisibleCurrency
        self.currentVisibleBalance = currentVisibleBalance
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    AccountScreen()
}
