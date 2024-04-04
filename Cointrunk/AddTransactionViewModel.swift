import Foundation

final class AddTransactionViewModel {
    let categories: [TransactionCategory] = TransactionCategory.allCases
    
    func addTransaction(amount: Decimal, category: TransactionCategory) {
    }
}
