import Foundation
import CoreData


public class Food: NSManagedObject {

}
extension Food {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }
    
    @NSManaged public var calorieAmount: String
    @NSManaged public var foodName: String
    @NSManaged public var servingAmount: String
    @NSManaged public var userFoodDate: Date
    
    
    
}
