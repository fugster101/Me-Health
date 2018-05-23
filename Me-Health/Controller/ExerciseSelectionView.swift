
import UIKit

class ExerciseSelectionView: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var exerciseTable: UITableView!
    let exercises:[String] = ["Walking\n(GPS)", "Jogging\n(GPS)", "Running\n(GPS)", "Cycling\n(GPS)", "High-Intensity (HIIT)", "Weight Lifiting", "Calesthics", "Powerlifting"]
    let exerciseImages:[UIImage] = [#imageLiteral(resourceName: "walking"),#imageLiteral(resourceName: "jogging"),#imageLiteral(resourceName: "running"),#imageLiteral(resourceName: "cycling"),#imageLiteral(resourceName: "HITT"),#imageLiteral(resourceName: "weightLifting"),#imageLiteral(resourceName: "calisthenics"),#imageLiteral(resourceName: "powerLifting")]
    var selectedCell:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTemplate") as! CustomExerciseCellView
        cell.exerciseLabel.text = exercises[indexPath.row]
        cell.exerciseImage.image = exerciseImages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = exercises[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        backtoExerciseView(self)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! ExerciseView
        switch selectedCell {
        case exercises[0]:
            destinationView.exerciseTypeLabel.text = "Cardio"
            destinationView.exerciseLabel.text = "Walking"
            destinationView.exerciseImage.image = #imageLiteral(resourceName: "Walking Exercise Image")
            break
        case exercises[1]:
            destinationView.exerciseTypeLabel.text = "Cardio"
            destinationView.exerciseLabel.text = "Jogging"
            destinationView.exerciseImage.image = #imageLiteral(resourceName: "Jogging Exercise Image")
            break
        case exercises[2]:
            destinationView.exerciseTypeLabel.text = "Cardio"
            destinationView.exerciseLabel.text = "Running"
            destinationView.exerciseImage.image =  #imageLiteral(resourceName: "Exercise Onboaerd Image")
            break
        case exercises[3]:
            destinationView.exerciseTypeLabel.text = "Cardio"
            destinationView.exerciseLabel.text = "Cycling"
            destinationView.exerciseImage.image = #imageLiteral(resourceName: "Cycling Exercise Image")
            break
        case exercises[4]:
            destinationView.exerciseTypeLabel.text = "Cardio"
            destinationView.exerciseLabel.text = "HIIT"
            destinationView.exerciseImage.image =  #imageLiteral(resourceName: "HIIT Exercise Image")
            break
        case exercises[5]:
            destinationView.exerciseTypeLabel.text = "Strength"
            destinationView.exerciseLabel.text = selectedCell
            destinationView.exerciseImage.image = #imageLiteral(resourceName: "Weightlifting Exercise Image")
            break
        case exercises[6]:
            destinationView.exerciseTypeLabel.text = "Strength"
            destinationView.exerciseLabel.text = selectedCell
            destinationView.exerciseImage.image =  #imageLiteral(resourceName: "Calesthethics Exercise Image")
            break
        case exercises[7]:
            destinationView.exerciseTypeLabel.text = "Strength"
            destinationView.exerciseLabel.text = selectedCell
            destinationView.exerciseImage.image = #imageLiteral(resourceName: "Powerlifting Exercise Image")
            break
        default:
            break
        }
    }
    
    @IBAction func backtoExerciseView(_ sender: Any) {
        performSegue(withIdentifier: "selectiontoexerciseview", sender: self)
    }
}

