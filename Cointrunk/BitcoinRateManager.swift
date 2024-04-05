import Foundation
import CoreData

class BitcoinRateManager {
    private let bitcoinRateService: BitcoinRateService
    private let context: NSManagedObjectContext
    
    init(bitcoinRateService: BitcoinRateService = BitcoinRateService(), context: NSManagedObjectContext) {
        self.bitcoinRateService = bitcoinRateService
        self.context = context
    }

    func fetchLatestBitcoinRate(completion: @escaping (Result<Decimal, Error>) -> Void) {
        let fetchRequest = NSFetchRequest<BitcoinRate>(entityName: "BitcoinRate")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            let rates = try context.fetch(fetchRequest)
            if let lastRate = rates.first, Date().timeIntervalSince(lastRate.lastUpdated as Date) < 3600 {
                completion(.success(lastRate.rate as Decimal))
            } else {
                fetchRateFromAPI(completion: completion)
            }
        } catch {
            completion(.failure(error))
        }
    }

    
    private func fetchRateFromAPI(completion: @escaping (Result<Decimal, Error>) -> Void) {
        bitcoinRateService.fetchBitcoinRate { [weak self] result in
            switch result {
            case .success(let rateResponse):
                guard let rateString = rateResponse.bpi["USD"]?.rate,
                      let rate = Decimal(string: rateString) else {
                          completion(.failure(NSError(domain: "BitcoinRateManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid rate data"])))
                          return
                      }
                self?.saveRateToCoreData(rate: rate, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveRateToCoreData(rate: Decimal, completion: @escaping (Result<Decimal, Error>) -> Void) {
        let newRate = BitcoinRate(context: context)
        newRate.id = UUID()
        newRate.rate = NSDecimalNumber(decimal: rate)
        newRate.lastUpdated = Date()
        
        do {
            try context.save()
            completion(.success(rate))
        } catch {
            completion(.failure(error))
        }
    }
}
