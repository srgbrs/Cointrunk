import Foundation
import CoreData

@objc(WalletBalance)
public class WalletBalance: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var amount: NSDecimalNumber
}
