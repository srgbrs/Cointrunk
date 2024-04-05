import Foundation

final class BitcoinRateService {
    
    func fetchBitcoinRate(completion: @escaping (Result<BitcoinRateResponse, Error>) -> Void) {
        
        let urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BitcoinRateService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "BitcoinRateService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let bitcoinRateResponse = try JSONDecoder().decode(BitcoinRateResponse.self, from: data)
                completion(.success(bitcoinRateResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
