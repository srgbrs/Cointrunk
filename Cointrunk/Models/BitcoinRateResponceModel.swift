import Foundation

struct BitcoinRateResponse: Codable {
    let time: TimeInfo
    let disclaimer: String
    let chartName: String
    let bpi: [String: CurrencyInfo]
    
    struct TimeInfo: Codable {
        let updatedISO: String
    }
    
    struct CurrencyInfo: Codable {
        let code: String
        let symbol: String
        let rate: String
        let description: String
        let rateFloat: Float

        enum CodingKeys: String, CodingKey {
            case code
            case symbol
            case rate
            case description
            case rateFloat = "rate_float"
        }
    }
}
