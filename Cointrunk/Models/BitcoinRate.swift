import Foundation
import CoreData

@objc(BitcoinRate)
public class BitcoinRate: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var rate: NSDecimalNumber
    @NSManaged public var lastUpdated: Date
}
