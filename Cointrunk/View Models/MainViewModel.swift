import Foundation
import CoreData
import UIKit

final class MainViewModel {
    private let bitcoinRateManager: BitcoinRateManager
    private var lastRate: BitcoinRate?
    let balanceService: WalletBalanceService
    
    private var transactions: [[Transaction]] = []
    
    var onRateUpdate: ((Decimal) -> Void)?
    var onDataLoaded: (() -> Void)?
    
    var onBalanceUpdated: ((NSDecimalNumber) -> Void)?
    var onTransactionsUpdated: (() -> Void)?
    
    var numberOfSections: Int {
        return transactions.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return transactions[section].count
    }
    
    func transactionForIndexPath(_ indexPath: IndexPath) -> Transaction {
        return transactions[indexPath.section][indexPath.row]
    }
    
    init(bitcoinRateManager: BitcoinRateManager = BitcoinRateManager(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext), balanceService: WalletBalanceService) {
        self.bitcoinRateManager = bitcoinRateManager
        self.balanceService = balanceService
    }
    
    func fetchLatestBitcoinRate() {
        bitcoinRateManager.fetchLatestBitcoinRate { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rate):
                    
                    self?.onRateUpdate?(rate)
                case .failure(let error):
                    print("Ошибка получения курса биткоина: \(error)")
                    
                }
            }
        }
    }
    
    func loadTransactions(page: Int = 0, completion: (() -> Void)? = nil) {
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending: false)]
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = page * 20

        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchedTransactions = try context.fetch(fetchRequest)

            let groupedTransactions = Dictionary(grouping: fetchedTransactions) { (transaction) -> Date in
                let calendar = Calendar.current
                let date = calendar.startOfDay(for: transaction.transactionDate as Date)
                return date
            }

            let sortedKeys = groupedTransactions.keys.sorted(by: >)

            let sortedGroups = sortedKeys.map { groupedTransactions[$0]! }

            self.transactions = sortedGroups

            completion?()
            onDataLoaded?()
        } catch {
            print("Ошибка загрузки транзакций: \(error)")
        }
    }

   
    func fetchCurrentBalance() {
        balanceService.fetchCurrentBalance { [weak self] balance in
            DispatchQueue.main.async {
                guard let balance = balance else {
                    print("Не удалось получить текущий баланс")
                    return
                }
                self?.onBalanceUpdated?(balance)
            }
        }}

    func updateBalance(amount: Decimal) {
         balanceService.updateBalance(with: amount, isAdding: true, category: "Пополнение") { [weak self] success in
             DispatchQueue.main.async {
                 if success {
                     
                     self?.loadTransactions()
                     self?.fetchAndUpdateBalanceDisplay()
                 } else {
                    
                 }
             }
         }
     }
     
    func fetchAndUpdateBalanceDisplay() {
        balanceService.fetchCurrentBalance { [weak self] balance in
            DispatchQueue.main.async {
                if let balance = balance {
                    self?.onBalanceUpdated?(balance)
                }
            }
        }
    }

    
}
