import Foundation
import UIKit

final class AddTransactionViewModel {
    let categories: [TransactionCategory] = TransactionCategory.allCases
    private let balanceService: WalletBalanceService
    
    var onTransactionAdded: (() -> Void)?
    
    enum AmountValidationResult {
        case success(Decimal)
        case failure(String)
    }
    init(balanceService: WalletBalanceService) {
          self.balanceService = balanceService
      }

    func validateAmount(_ amountString: String?) -> AmountValidationResult {
        guard let amountString = amountString, !amountString.isEmpty else {
            return .failure("Поле суммы не может быть пустым")
        }
        guard let amount = Decimal(string: amountString), amount > 0 else {
            return .failure("Сумма должна быть положительным числом")
        }
        
        return .success(amount)
    }
    
    func addTransaction(amount: Decimal, category: TransactionCategory, completion: @escaping (Bool, String?) -> Void) {
        balanceService.canPerformTransaction(amount: amount) { [weak self] canPerform in
            guard canPerform else {
                completion(false, nil)
                return
            }
            
            let context = self?.balanceService.publicContext ?? (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let transaction = Transaction(context: context)
            transaction.amount = NSDecimalNumber(decimal: amount)
            transaction.category = category.rawValue
            transaction.transactionDate = Date()
            
            self?.balanceService.updateBalance(with: amount, isAdding: false) { success in
                guard success else {
                    completion(false, nil)
                    
                    return
                }
                do {
                    try context.save()
                    completion(true, nil)
                    self?.onTransactionAdded?()
                } catch {
                    print("Ошибка сохранения транзакции: \(error)")
                    completion(false, nil)
                }
            }
        }
    }


}
