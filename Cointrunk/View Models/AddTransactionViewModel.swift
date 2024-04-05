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
                completion(false, "Недостаточно средств для выполнения транзакции")
                return
            }
            
            
            self?.balanceService.updateBalance(with: amount, isAdding: false, category: category.rawValue) { success in
                guard success else {
                    completion(false, "Ошибка при обновлении баланса")
                    return
                }
                completion(true, nil)
                self?.onTransactionAdded?()
            }
        }
    }

}
