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

            let groupedTransactions = Dictionary(grouping: fetchedTransactions) { (transaction) -> DateComponents in
                return Calendar.current.dateComponents([.year, .month, .day], from: transaction.transactionDate)
            }.values.map { Array($0) }
            self.transactions.append(contentsOf: groupedTransactions)
            completion?()
            onDataLoaded?()
        } catch {
            print("Ошибка загрузки транзакций: \(error)")
        }
    }

}
