import Foundation
import CoreData


public class Calorie: NSManagedObject {

}
extension Calorie {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calorie> {
        return NSFetchRequest<Calorie>(entityName: "Calorie")
    }
    
    @NSManaged public var totalCalorie: String
    @NSManaged public var date: Date
    
}
