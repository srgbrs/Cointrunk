import Foundation
import UIKit
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var category: String
    @NSManaged public var transactionDate: Date
    @NSManaged public var descriptionText: String?

    convenience init(id: UUID = UUID(), type: String, amount: Decimal, category: String, transactionDate: Date, descriptionText: String? = nil) {
  
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.type = type
        self.amount = amount as NSDecimalNumber
        self.category = category
        self.transactionDate = transactionDate
        self.descriptionText = descriptionText
    }
}
