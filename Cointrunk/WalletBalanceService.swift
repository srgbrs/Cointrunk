
import UIKit
import CoreData

class WalletBalanceService {
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

    func updateBalance(with newAmount: Decimal, isAdding: Bool, completion: @escaping (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<WalletBalance>(entityName: "WalletBalance")
        do {
            let result = try context.fetch(fetchRequest)
            if let balance = result.first {
                if isAdding {
                    balance.amount = balance.amount.adding(NSDecimalNumber(decimal: newAmount))
                } else {
                    let potentialNewBalance = balance.amount.subtracting(NSDecimalNumber(decimal: newAmount))
                    if potentialNewBalance.compare(NSDecimalNumber.zero) == .orderedAscending {
                        completion(false)
                        return
                    }
                    balance.amount = potentialNewBalance
                }
                try context.save()
                completion(true)
            } else {
   
                let newBalance = WalletBalance(context: context)
                newBalance.amount = NSDecimalNumber(decimal: newAmount)
                newBalance.id = UUID()
                try context.save()
                completion(true)
            }
        } catch {
            print("Ошибка при обновлении баланса:", error)
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
