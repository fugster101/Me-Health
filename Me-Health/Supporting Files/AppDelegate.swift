import UIKit
import CoreLocation
import CoreData
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = storyboard.instantiateViewController(withIdentifier: "Onboard")
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onboardComplete")  {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "MainApp")
        }
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        UserDefaults.standard.synchronize()
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        setUpUserNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication){
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func setUpUserNotifications()  {
        UNUserNotificationCenter.current().getNotificationSettings { (userSettings) in
            switch userSettings.authorizationStatus{
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert] , completionHandler: { (granted, error) in
                    if granted{
                        let content = UNMutableNotificationContent()
                        content.title = "Me-Health"
                        content.body = "Wait you waiting for, lets do some exercise today"
                        content.badge = 1
                        content.sound = UNNotificationSound.default()
                        
                        var date = DateComponents()
                        date.hour = 9
                        date.minute = 30
                        _ = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                    }
                })
            case .authorized:
                let content = UNMutableNotificationContent()
                content.title = "Me-Health"
                content.body = "Wait you waiting for, lets do some exercise today"
                content.badge = 1
                content.sound = UNNotificationSound.default()
                var date = DateComponents()
                date.hour = 9
                date.minute = 30
                _ = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                
            case .denied:
                break
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Me-Health"
        content.body = "Wait you waiting for, lets do some exercise today"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        var date = DateComponents()
        date.hour = 9
        date.minute = 30
        _ = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    }
}

