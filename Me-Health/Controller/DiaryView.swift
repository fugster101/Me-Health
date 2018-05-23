import UIKit
import SwifterSwift
import CoreData


class DiaryView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    var counter: Double = 0
    var food = [Food]()
    var calorie = [Calorie]()
    
    @IBOutlet weak var userFoodTextField: UITextField!
    @IBOutlet weak var userCaloriesTextField: UITextField!
    @IBOutlet weak var userServingTextField: UITextField!
    @IBOutlet weak var foodTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsersFood()
        fetchUsersCalories()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTable.delegate = self
        foodTable.dataSource = self
    }
    @IBAction func insertFoodAction(_ sender: Any) {
        insertFoodAction()
    }
}
extension DiaryView{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.food.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! DiaryViewCustomCell
        let foods = food[indexPath.row]
        cell.foodnameLabel.text = foods.foodName
        cell.calorieamountLabel.text = foods.calorieAmount + " " + "kcal"
        cell.servingLabel.text = foods.servingAmount + " " + "servings"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let lastCalorieAmount = calorie[indexPath.row]
            let lastServingAmount = food[indexPath.row]
            counter = lastCalorieAmount.totalCalorie.double()! - (lastServingAmount.servingAmount.double()! * lastServingAmount.calorieAmount.double()!)
            deleteUserFood(at: indexPath)
            saveLastestCalories(updatedValue: counter)
            foodTable.beginUpdates()
            foodTable.deleteRows(at: [indexPath], with: .automatic)
            foodTable.endUpdates()
            view.endEditing(true)
        default:
            break
        }
    }
    func insertFoodAction()  {
        if userFoodTextField.text == "" || userCaloriesTextField.text  == "" || userServingTextField.text == "" {
            userFoodTextField.shake()
            userCaloriesTextField.shake()
            userServingTextField.shake()
        }
        else {
            counter = counter + (userCaloriesTextField.text?.withoutSpacesAndNewLines.double())! * (userServingTextField.text?.withoutSpacesAndNewLines.double())!
            saveUserFood()
            saveLastestCalories(updatedValue: counter)
            userFoodTextField.text = ""
            userCaloriesTextField.text = ""
            userServingTextField.text = ""
            view.endEditing(true)
        }
    }
    
    func saveUserFood()  {
        guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext =  applicationDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)!
        let foods = Food(entity: entity, insertInto: managedContext)
        foods.foodName = (userFoodTextField.text?.trimmed)!
        foods.calorieAmount = (userCaloriesTextField.text?.trimmed)!
        foods.servingAmount = (userServingTextField.text?.trimmed)!
        foods.userFoodDate = Date()
        self.food.append(foods)
        do{
            try managedContext.save()
            let indexPathFood = IndexPath(row: food.count - 1, section: 0)
            self.foodTable.beginUpdates()
            self.foodTable.insertRows(at: [indexPathFood], with: .automatic)
            self.foodTable.endUpdates()
        } catch let error as NSError{
            print("Could not save user food and insert cell. \(error.userInfo)")
        }
    }
    
    func deleteUserFood(at indexPath: IndexPath)  {
        guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = applicationDelegate.persistentContainer.viewContext
        context.delete(food[indexPath.row] as NSManagedObject)
        self.food.remove(at:indexPath.row)
        do{
            try context.save()
        } catch let error as NSError{
            print("Could not save user food. \(error.userInfo)")
        }
    }
    
    func saveLastestCalories(updatedValue:Double)  {
        guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedContext =  applicationDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Calorie", in: managedContext)!
        let calories = Calorie(entity: entity, insertInto: managedContext)
        calories.totalCalorie = updatedValue.int.string
        calories.date = Date()
        do{
            calorie.append(calories)
            try managedContext.save()
            print(calories)
        } catch let error as NSError{
            print("Could not save user calories. \(error.userInfo)")
        }
    }
    
    func fetchUsersFood() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fecthRequest = NSFetchRequest<NSManagedObject>(entityName: "Food")
        fecthRequest.sortDescriptors = [NSSortDescriptor(key: "userFoodDate", ascending: true)]
        do {
            food = try managedObjectContext.fetch(fecthRequest) as! [Food]
            self.foodTable.reloadData()
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    func fetchUsersCalories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fecthRequest = NSFetchRequest<NSManagedObject>(entityName: "Calorie")
        fecthRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            calorie = try managedObjectContext.fetch(fecthRequest) as! [Calorie]
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
