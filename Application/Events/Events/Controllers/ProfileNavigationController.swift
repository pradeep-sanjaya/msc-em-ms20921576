import UIKit

class ProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let storyboardLogin : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let touchIdViewController = storyboardLogin.instantiateViewController(withIdentifier: "TouchIdViewController") as! TouchIdViewController
        
        let storyboardMain : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboardMain.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        touchIdViewController.nextViewController = profileViewController
            
        self.viewControllers = [touchIdViewController]
    }

}
