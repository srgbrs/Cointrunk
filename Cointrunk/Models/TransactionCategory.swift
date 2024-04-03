import Foundation

enum TransactionCategory: String, CaseIterable {
    case groceries = "Groceries"
    case taxi = "Taxi"
    case electronics = "Electronics"
    case restaurant = "Restaurant"
    case other = "Other"
    
    func toString() -> String {
        return self.rawValue
    }
    
    static func fromString(_ string: String) -> TransactionCategory? {
        return self.allCases.first(where: { $0.rawValue == string })
    }
}
