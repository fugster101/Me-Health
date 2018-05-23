import UIKit
import SwifterSwift

class MoreSelectionView: UITableViewController {
    
    let options:[String] = ["Calorie Calculator", "Macro Calculator","Body-Fat","Diets","Workouts","BodyBuilding"]
    var selectedOption = ""
    let moreImages: [UIImage] = [#imageLiteral(resourceName: "calorie"),#imageLiteral(resourceName: "macro"),#imageLiteral(resourceName: "bodyFat"),#imageLiteral(resourceName: "diet"),#imageLiteral(resourceName: "workout"),#imageLiteral(resourceName: "bodyBuilding")]
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreCustomCellView
        cell.moreLabel.text = options[indexPath.row]
        cell.moreImage.image = moreImages[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOption = options[indexPath.row]
        performSegue(withIdentifier: "selectiontowebview", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! MoreWebView
        switch selectedOption {
        case options[0]:
            destinationView.giveURL = "https://www.freedieting.com/calorie-calculator"
            break
        case options[1]:
            destinationView.giveURL = "https://www.freedieting.com/nutrient-calculator"
            break
        case options[2]:
            destinationView.giveURL = "https://www.freedieting.com/body-fat-calculator"
            break
        case options[3]:
            destinationView.giveURL = "https://www.freedieting.com"
            break
        case options[4]:
            destinationView.giveURL = "https://www.freedieting.com/exercise"
            break
        case options[5]:
            destinationView.giveURL = "https://www.bodybuilding.com"
            break
        default:
            
            break
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
