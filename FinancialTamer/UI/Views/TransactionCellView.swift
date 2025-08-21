import SwiftUI

struct TransactionCellView : View {
    let transaction: Transaction
    
    private var isOutcome: Bool {
        transaction.category.direction == .outcome
    }
    
    private var emojiBubble: some View {
        ZStack {
            Circle()
                .fill(Color.green.opacity(0.2))
                .frame(width: 33, height: 33)
            Text(transaction.category.emoji.description)
                .font(.title2)
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            if isOutcome {
                emojiBubble
            }
            
            if ((transaction.comment?.isEmpty) != nil) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(transaction.category.name).font(.body)
                    Text(transaction.comment ?? "")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            } else {
                VStack {
                    Spacer()
                    Text(transaction.category.name)
                        .font(.body)
                    Spacer()
                }
            }
            
            Spacer()
            
            HStack(spacing: 5) {
                Text(transaction.amount.description)
                Text(transaction.account.currency)
                    .padding(.trailing, 7)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 1)
        .background(Color(.systemBackground))
    }
}

#Preview {
    TransactionsListView(direction: .outcome, title: "Доходы сегодня")
}
