import UIKit
import UserNotifications
import Motion

class AppTabController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        isMotionEnabled = true
        motionTabBarTransitionType = .fade
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


