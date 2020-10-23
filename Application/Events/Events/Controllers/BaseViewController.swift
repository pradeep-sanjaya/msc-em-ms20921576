import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class BaseViewController: UIViewController {

    public let userService = UserService()
    public let storageService = StorageService()
    public let eventService = EventService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setRootViewController(name: String) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: name)
        UIApplication.shared.windows.first?.rootViewController = rootViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
