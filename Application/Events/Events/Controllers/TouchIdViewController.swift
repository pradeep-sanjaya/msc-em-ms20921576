import UIKit
import LocalAuthentication

class TouchIdViewController: BaseViewController {
    
    let biometricAuthService = BiometricAuthService()
    public var nextViewController: UIViewController?
    
    @IBOutlet weak var biometricLoginOutlet: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // show/hide button and show relevant image
        setupBiometricButton()
        
        // authenticate with biometric
        autheticateUser()
    }
    
    @IBAction func biometricLoginAction(_ sender: UIButton) {
        autheticateUser()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        self.userService.signOut()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController
        
        UIApplication.shared.windows.first?.rootViewController = mainNavigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func setupBiometricButton() {
        biometricLoginOutlet.isHidden = !biometricAuthService.canEvaluatePolicy()
        print("isHidden: \(biometricLoginOutlet.isHidden)")
        
        switch biometricAuthService.biometricType() {
        case .faceID:
            biometricLoginOutlet.setImage(UIImage(named: "faceIcon"),  for: .normal)
        case .touchID:
            biometricLoginOutlet.setImage(UIImage(named: "touchIcon"),  for: .normal)
        default:
            biometricLoginOutlet.setImage(UIImage(),  for: .normal)
        }
    }
    
    func autheticateUser() {
        biometricAuthService.authenticateUser() {[weak self] message in
            if let message = message {

            } else {

                if let viewController = self?.nextViewController! {
                    if viewController is MainTabBarController {
                        UIApplication.shared.windows.first?.rootViewController = viewController
                    } else {
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
    
}
