import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserMode.isAnonymous {
            let index = [2,1]
            index.forEach{
                viewControllers?.remove(at: $0)
            }
        }
    }
}
