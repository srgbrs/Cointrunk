
import UIKit
import CoreData

final class WalletBalanceService {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    var publicContext: NSManagedObjectContext {
            return context
        }


    func fetchCurrentBalance(completion: @escaping (NSDecimalNumber?) -> Void) {
        let fetchRequest = NSFetchRequest<WalletBalance>(entityName: "WalletBalance")
        do {
            let result = try context.fetch(fetchRequest)
            let currentBalance = result.first?.amount
            completion(currentBalance)
        } catch {
            print("Ошибка при извлечении баланса:", error)
            completion(nil)
        }
    }
    
    func updateBalance(with newAmount: Decimal, isAdding: Bool, category: String, completion: @escaping (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<WalletBalance>(entityName: "WalletBalance")
        do {
            let result = try context.fetch(fetchRequest)
            if let balance = result.first {
                let finalAmount = isAdding ? balance.amount.adding(NSDecimalNumber(decimal: newAmount)) : balance.amount.subtracting(NSDecimalNumber(decimal: newAmount))
       
                if !isAdding && finalAmount.compare(NSDecimalNumber.zero) == .orderedAscending {
                    completion(false)
                    return
                }
                
                balance.amount = finalAmount
                    

                addTransaction(amount: newAmount, isAdding: isAdding, category: category) { success in
                    guard success else {
                        completion(false)
                        return
                    }
                    

                    do {
                        try self.context.save()
                        completion(true)
                    } catch {
                        print("Ошибка при обновлении баланса:", error)
                        completion(false)
                    }
                }
            } else {

                let newBalance = WalletBalance(context: context)
                newBalance.amount = NSDecimalNumber(decimal: newAmount)
                newBalance.id = UUID()
                    
                addTransaction(amount: newAmount, isAdding: true, category: category) { success in
                    guard success else {
                        completion(false)
                        return
                    }
                    
                    do {
                        try self.context.save()
                        completion(true)
                    } catch {
                        print("Ошибка при создании нового баланса:", error)
                        completion(false)
                    }
                }
            }
        } catch {
            print("Ошибка при обновлении баланса:", error)
            completion(false)
        }
    }


    
    func addTransaction(amount: Decimal, isAdding: Bool, category: String, completion: @escaping (Bool) -> Void) {
        let transaction = Transaction(context: context)
        transaction.amount = NSDecimalNumber(decimal: amount)
        transaction.transactionDate = Date()
        transaction.category = category
        transaction.type = isAdding ? "доход" : "расход"
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Ошибка при сохранении транзакции:", error)
            completion(false)
        }
    }

    
    func canPerformTransaction(amount: Decimal, completion: @escaping (Bool) -> Void) {
           fetchCurrentBalance { balance in
               let currentBalance = balance ?? NSDecimalNumber.zero
               let newBalance = currentBalance.subtracting(NSDecimalNumber(decimal: amount))
               completion(newBalance.compare(NSDecimalNumber.zero) != .orderedAscending)
           }
       }
    
}
