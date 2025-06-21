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
        HStack(spacing: 12) {
            if isOutcome {
                emojiBubble
            }
                
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category.name).font(.body)
                if let comment = transaction.comment {
                    Text(comment)
                        .font(.caption2)
                        .foregroundColor(.gray)
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
            .padding(.vertical, 2)
            .background(Color(.systemBackground))
        }
}
