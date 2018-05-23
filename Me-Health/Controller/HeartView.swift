import UIKit
import Motion
import CoreData
class HeartView: UIViewController, NSFetchedResultsControllerDelegate {
    
    var userName = ""
    var Calorie:[NSManagedObject] = []
    let exercises:[String] = ["Walking", "Jogging", "Running", "Cycling", "High-Intensity (HIIT)", "Weight Lifiting", "Calesthics", "Powerlifting"]
    
    let userHour = Date().hour
    let userDayName = Date().dayName()
    let userDay = Date().day.string
    let userMonth = Date().monthName()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var exerciseSuggestionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userBackgroundImage: UIImageView!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userAvgPace: UILabel!
    @IBOutlet weak var userRecoredTime: UILabel!
    @IBOutlet weak var userSteps: UILabel!
    @IBOutlet weak var userCalories: UILabel!
    @IBOutlet weak var userExercise: UILabel!
    @IBOutlet weak var caloriesRemaining: UILabel!
    @IBOutlet weak var stepsRemaining: UILabel!
    @IBOutlet weak var userGoalCalories: UILabel!
    @IBOutlet weak var userGoalSteps: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.defaultChecks()
        self.setuprecomendation()
        self.setdayNameDay()
        self.getUserData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults()
        if userDefaults.object(forKey: "userName") == nil {
            userName = ""
        }else{
            userName = userDefaults.object(forKey: "userName") as! String
        }
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(HeartView.defaultChecks) , userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(HeartView.setdayNameDay) , userInfo: nil, repeats: true)
        self.userImage.cornerRadius = userImage.frame.width / 2
        self.userImage.contentMode = .scaleAspectFill
        if  userDefaults.object(forKey: "userImage") != nil {
            let data = userDefaults.object(forKey: "userImage") as! Data
            let userDataImage = UIImage(data: data)
            
            if userDataImage == #imageLiteral(resourceName: "ImagePickerView") {
                self.userBackgroundImage.backgroundColor = UIColor(hexString: "3B4142")
            }else{
                self.userImage.image = userDataImage
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
                visualEffectView.frame = self.userBackgroundImage.bounds
                self.userBackgroundImage.addSubview(visualEffectView)
                self.userBackgroundImage.image = userDataImage
            }
        } else{
            self.userImage.image = #imageLiteral(resourceName: "ImagePickerView")
            self.userBackgroundImage.backgroundColor = UIColor(hexString: "3B4142")
        }
    }
}
extension HeartView{
    
    // default seet up when interface loads in checks if the application is the first time loading in
    @objc func defaultChecks()  {
        let sessionNumber = UserDefaults.standard.value(forKey: "launchCount") as! Int
        if  sessionNumber == 1{
            self.exerciseSuggestionLabel.text = "Since your new here familrise yourself with the application and its features"
        }
        self.welcomeLabel.text = "Hello \(self.userName),"
    }
    
    public func setuprecomendation(){
        let recomedation = self.exercises.shuffled().first.unsafelyUnwrapped
        self.exerciseSuggestionLabel.text = "We think you should complete a \(recomedation) session"
    }
    
    // checks the time of day aand sets the time of day label
    @objc func  setdayNameDay(){
        dateLabel.text = userDayName + "," + " " +  userMonth  + " " + userDay
    }
    
    //get the user data using fetch method in core data stack
    func getUserData()  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchUserCaloriesRequest = NSFetchRequest<NSManagedObject>(entityName: "Calorie")
        fetchUserCaloriesRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchUserCaloriesRequest.fetchLimit = 1
        do {
            let result  = try managedObjectContext.fetch(fetchUserCaloriesRequest) as! [Calorie]
            if result.isEmpty {
                self.userCalories.text = "0"
                self.caloriesRemaining(goalCalories: (self.userGoalCalories.text?.int)!, userlatestCalories: (self.userCalories.text?.int)!)
            }else{
                if result[0].totalCalorie == "0"{
                    self.userCalories.text = "0"
                } else{
                    self.userCalories.text = result[0].totalCalorie
                }
                self.caloriesRemaining(goalCalories: (self.userGoalCalories.text?.int)!, userlatestCalories: (self.userCalories.text?.int)!)
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
        
        let fetchUserExercise = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        fetchUserExercise.sortDescriptors = [NSSortDescriptor(key: "exerciseDate", ascending: false)]
        fetchUserExercise.fetchLimit = 1
        do {
            let result  = try managedObjectContext.fetch(fetchUserExercise) as! [Exercise]
            if result.isEmpty {
                self.userSteps.text = "0"
                self.userDistance.text = "0" + " " + "m"
                self.userAvgPace.text = "0" + " " + "mph"
                self.userRecoredTime.text = "00:00:00"
                self.userExercise.text = "None"
            }else{
                if result[0].exerciseType == "Cardio" {
                    self.userSteps.text = result[0].userSteps
                    self.userDistance.text = result[0].userDistance
                    self.userAvgPace.text = result[0].userPace
                    self.userRecoredTime.text = result[0].userTime
                    self.userExercise.text = result[0].exerciseName
                    stepsRemaining(goalSteps: (self.userGoalSteps.text?.int)!, userlatestSteps: (self.userSteps.text?.int)!)
                } else{
                    
                    if result[0].userSteps == "0" || result[0].userSteps == ""{
                        self.userSteps.text = "0"
                        stepsRemaining(goalSteps: (self.userGoalSteps.text?.int)!, userlatestSteps: (self.userSteps.text?.int)!)
                    }
                    else{
                        self.userSteps.text = result[0].userSteps
                        stepsRemaining(goalSteps: (self.userGoalSteps.text?.int)!, userlatestSteps: (self.userSteps.text?.int)!)
                    }
                    self.userDistance.text = "N/A"
                    self.userAvgPace.text = "N/A"
                    self.userRecoredTime.text = result[0].userTime
                    self.userExercise.text = result[0].exerciseName
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    // to calculate the users calorie remaining
    func caloriesRemaining(goalCalories:Int, userlatestCalories:Int)  {
        let totalCalories = goalCalories - userlatestCalories
        self.caloriesRemaining.text = totalCalories.string
    }
    
     // to calculate the users steps remaining
    func stepsRemaining(goalSteps:Int, userlatestSteps:Int)  {
        let totalSteps = goalSteps - userlatestSteps
        self.stepsRemaining.text = totalSteps.string
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
