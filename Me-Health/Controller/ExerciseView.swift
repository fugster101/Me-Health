import UIKit
import Motion
import CoreMotion
import CoreLocation
import SwifterSwift
import CoreData

class ExerciseView: UIViewController, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
  
  //Core data object array
  var exercises = [Exercise]()
  
  //Timer Variables
  var startTime = TimeInterval()
  var timer = Timer()
  var recordedTime:String = ""
  var numberoOfSteps:String = ""
  var distanceRecorded:String = ""
  var userPace:String = ""
  
  //Manager Variables
  let activityManager = CMMotionActivityManager()
  let locationManager = CLLocationManager()
  
  // Start and End location variables
  var currentLocation: CLLocation?
  var endLocation: CLLocation?
  
  //Pedomeater variable
  let pedometer = CMPedometer()
  
  //All Button outlets
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var exerciseTypeLabel: UILabel!
  @IBOutlet weak var exerciseLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var exerciseImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLocationManager()
    stopButton.isEnabled = false
  }
  
  @IBAction func playButton(_ sender: Any) {
    playFunction()
  }
  
  @IBAction func stopButton(_ sender: Any) {
    stopFunction()
  }
  
  @IBAction func resetButton(_ sender: Any) {
    resetFunction()
  }
  
}

extension ExerciseView{
  
  fileprivate func setUpLocationManager() {
    if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestAlwaysAuthorization()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.activityType = .fitness
    }
    else if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted{
      locationManager.requestAlwaysAuthorization()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.activityType = .fitness
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locations.first
    endLocation = locations.last
  }
  func resetFunction()  {
    if exerciseLabel.text != "Pick an Exercise" {
      //Alert Contoller housing two UIAlertActions
      let alertResetData = UIAlertController.init(
        title: "Clear Activity",
        message: "Are you sure you want to reset the current activity",
        preferredStyle: .alert)
      // Yes Action and completion block
      let Yes = UIAlertAction.init(
        title: "Yes",
        style: .default,
        handler:
        { (action) in
          self.timer.invalidate()
          self.stopButton.isEnabled = false
          self.startButton.isEnabled = true
          self.timeLabel.animate([MotionAnimation.fadeIn], completion: {
            self.timeLabel.text = "00:00:00"
          })
          self.exerciseTypeLabel.animate([MotionAnimation.fadeIn], completion: {
            self.exerciseTypeLabel.text = "None"
          })
          self.exerciseLabel.animate([MotionAnimation.fadeIn], completion: {
            self.exerciseLabel.text = "Pick an Exercise"
          })
          
          self.exerciseImage.image = #imageLiteral(resourceName: "Personal Trainer Exercise Image")
      })
      // Cancel Action
      let Cancel = UIAlertAction.init(
        title: "No",
        style: .destructive,
        handler: nil)
      
      // Add too alert actions to alert controller and present in the current view
      alertResetData.addAction(Yes)
      alertResetData.addAction(Cancel)
      self.present(alertResetData, animated: true, completion: nil)
    }
    else
    {
      //Alert controller initiliser
      let alertExerciseData  = UIAlertController.init(title: "No Exercise Data",
                                                      message: "Please choose a exercise",
                                                      preferredStyle: .alert)
      // Aleert action "ok" initiliser
      let ok = UIAlertAction.init(title: "OK",
                                  style: .cancel,
                                  handler: nil)
      
      // Add teo alert actions to alert controller and present in the current view
      alertExerciseData.addAction(ok)
      self.present(alertExerciseData, animated: true, completion: nil)
    }
  }
  @objc func updateTime() {
    let currentTime = Date.timeIntervalSinceReferenceDate
    var elapsedTime: TimeInterval = currentTime - startTime
    
    let minutes = UInt8(elapsedTime/60.0)
    elapsedTime -= (TimeInterval(minutes) * 60.0)
    
    let seconds = UInt8(elapsedTime)
    elapsedTime -= TimeInterval(seconds)
    
    let fraction = UInt8(elapsedTime * 100)
    
    let strMinutes = String(format: "%02d", minutes)
    let strSeconds = String(format: "%02d", seconds)
    let strFraction = String(format: "%02d", fraction)
    
    timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
  }
  
  //Play timer function
  func playFunction()  {
    if exerciseLabel.text != "Pick an Exercise" {
      DispatchQueue.main.async {
        let aSelector : Selector = #selector(self.updateTime)
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        self.startTime = Date.timeIntervalSinceReferenceDate
        self.startButton.isEnabled = false
        self.stopButton.isEnabled = true
      }
      if CLLocationManager.locationServicesEnabled(){
        if self.exerciseTypeLabel.text == "Cardio"{
          locationManager.startUpdatingLocation()
        }
      }
      activityStart()
    }
    else{
      noExerciseSelectedAlert()
    }
  }
  
  fileprivate func activityStart() {
    let date = Date()
    pedometer.startUpdates(from: date) { (userData, error) in
      if userData != nil{
        let kilo:Float = 1000.0
        self.numberoOfSteps = (userData?.numberOfSteps.stringValue)!
        
        if (userData?.distance?.floatValue)! > kilo{
          self.distanceRecorded = String(format: "%.2f", ((userData?.distance?.floatValue)! / kilo)) + " " + "km"
        }
        else
        {
          self.distanceRecorded = String(format: "%.2f", (userData?.distance?.floatValue)!) + " " + "m"
        }
        
        self.userPace = String(format: "%.2f", (userData?.averageActivePace?.floatValue)!) + " " + "mph"
      }
      else if (userData?.distance == 0 && (userData?.numberOfSteps == 0)){
        self.numberoOfSteps = "0"
        self.distanceRecorded = "0"
        
      }
    }
  }
  
  fileprivate func noExerciseSelectedAlert() {
    let alert2  = UIAlertController.init(
      title: "No Exercise Selected",
      message: "Please choose a exercise to start tracking your workout",
      preferredStyle: .alert)
    let ok = UIAlertAction.init(
      title: "OK",
      style: .cancel,
      handler: nil)
    alert2.addAction(ok)
    self.present(
      alert2,
      animated: true,
      completion: nil)
  }
  
  
  //Stop Butoon action
  func stopFunction()  {
    stopButton.isEnabled = false
    
    let finishedActivityAlet = UIAlertController.init(
      title:"Exercise Complete",
      message: "Are you sure you have finished the current activity",
      preferredStyle: .alert)
    
    finishedActivityAlet.addAction(UIAlertAction.init(
      title: "Save",
      style: .default,
      handler: { (action) in
        self.locationManager.stopUpdatingLocation()
        self.activityStop()
    }))
    
    finishedActivityAlet.addAction(UIAlertAction.init(
      title: "Cancel",
      style: .destructive,
      handler: {(action) in
        self.stopButton.isEnabled = true
    }))
    
    self.present(finishedActivityAlet, animated: true) {
    }
  }
  
  fileprivate func activityStop(){
    
    pedometer.stopUpdates()
    
    //Stop the timer and set the exercise elapsed time
    self.timer.invalidate()
    self.recordedTime = self.timeLabel.text!
    
    //Saving the current users exercise to local storage
    saveCurrentExercise()
    
    //perform segue inconjunction withe prepare fucntion
    if exerciseLabel.text == "Walking" || exerciseLabel.text == "Jogging" || exerciseLabel.text == "Running" || exerciseLabel.text == "Cycling"    {
      if CLLocationManager.locationServicesEnabled(){
        self.performSegue(withIdentifier: "exerciseToResults", sender: self)
      }
    }
    //Reset default values/states of the labels and buttons
    self.startButton.isEnabled = true
    self.exerciseTypeLabel.text = "None"
    self.exerciseLabel.text = "Pick an Exercise"
    self.timeLabel.text = "00:00:00"
    self.exerciseImage.image = #imageLiteral(resourceName: "Personal Trainer Exercise Image")
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "exerciseToResults" {
      let destinationView = segue.destination as! ExerciseResultView
      destinationView.timefrompreviousView = self.recordedTime
      destinationView.stepsfrompreviousView = self.numberoOfSteps
      destinationView.distancefrompreviousview = self.distanceRecorded
      destinationView.startingCordinates = self.currentLocation?.coordinate
      destinationView.endingCordinates = self.endLocation?.coordinate
    }
  }
  
  func saveCurrentExercise() {
    guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
    let managedContext =  applicationDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: managedContext)!
    let exercise = Exercise(entity: entity, insertInto: managedContext)
    exercise.exerciseDate = Date()
    exercise.exerciseName = self.exerciseLabel.text!
    exercise.exerciseType = self.exerciseTypeLabel.text!
    exercise.userDistance = self.distanceRecorded
    exercise.userTime = self.recordedTime
    exercise.userPace = self.userPace
    exercise.userSteps = self.numberoOfSteps
    do{
      try managedContext.save()
      exercises.append(exercise)
    } catch let error as NSError{
      print("Could not save user food. \(error.userInfo)")
    }
  }
  
  @IBAction func unwindTothisVC(segue:UIStoryboardSegue) {
    
  }
}

