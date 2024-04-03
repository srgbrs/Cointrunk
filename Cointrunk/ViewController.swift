import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bitcoinRateService = BitcoinRateService()
        bitcoinRateService.fetchBitcoinRate { result in
//            switch result {
//            case .success(let rateResponse):
//                print("Курс биткоина: \(rateResponse.bpi["USD"]?.rate ?? "unknown") USD")
//            case .failure(let error):
//                print("Ошибка получения курса биткоина: \(error.localizedDescription)")
//            }
        }
        
    }
}

