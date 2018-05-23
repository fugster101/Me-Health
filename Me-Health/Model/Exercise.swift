import Foundation
import CoreData


public class Exercise: NSManagedObject {

}
extension Exercise {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }
    
    @NSManaged public var exerciseName: String
    @NSManaged public var exerciseType: String
    @NSManaged public var userDistance: String
    @NSManaged public var userPace: String
    @NSManaged public var userSteps: String
    @NSManaged public var userTime: String
    @NSManaged public var exerciseDate: Date
}
