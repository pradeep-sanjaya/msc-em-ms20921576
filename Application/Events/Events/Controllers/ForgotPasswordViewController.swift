import UIKit
import Firebase

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        
        validate()
        print("email: \(emailTxt.text!)")
        
        Auth.auth().sendPasswordReset(withEmail: emailTxt.text!) {
            error in
            if error != nil {
                print(error)
                self.presentHideAlert(withTitle: "NIBM Events", message: "An error occurred")
            } else {
                self.presentHideAlert(withTitle: "NIBM Events", message: "Password reset link sent to email")
            }
        }
    }
    
    func validate() {
        
        guard let email = emailTxt.text, email != "" ,
            Validator.isValidEmail(email) else {
            print("email is empty")
            UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: false)
            return
        }
        
        UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: true)

        print("email: \(email)")
    }
}
