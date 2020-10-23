import UIKit
import FacebookCore
import Firebase

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    var user: User?
    
    /* Views */
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIControls()
        self.emailTxt.delegate = self
        self.passwordTxt.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func prepareUIControls() {
        preparePassword()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func preparePassword() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        passwordTxt.leftView = paddingView
        passwordTxt.leftViewMode = .always
        passwordTxt.layer.borderWidth = 1
        passwordTxt.layer.borderColor = UIColor.init(named: "DarkBlue")?.cgColor
        add(image: UIImage(named: "Eye")!, toTextField: passwordTxt)
    }
    
    public func add(image: UIImage, toTextField control: UITextField)  {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(control.frame.size.width - 40), y: CGFloat(5), width: CGFloat(40), height: CGFloat(40))
        button.addTarget(self, action: #selector(self.eyeTapped), for: .touchUpInside)
        control.rightView = button
        control.rightViewMode = .always
    }
    
    @objc func eyeTapped(_ sender: UIButton) {
        print("eye tapped")
        self.passwordTxt.isSecureTextEntry.toggle()
    }
    
    // MARK - Text fireld deligate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?

        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }

        return true
            
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    // MARK - Actions
    @IBAction func loginButt(_ sender: UIButton) {
        validateEmailAndPassword()
        
        guard emailTxt.text! != "", passwordTxt.text! != "" else {
            return
        }
        
        userService.login(withEmail: emailTxt.text!, password: passwordTxt.text!) {
            [weak self] error in
            guard let strongSelf = self else { return }
            
            if let err = error {
                print(err)
                self?.presentHideAlert(withTitle: Bundle.appName(), message: "Login error")
            } else {
                strongSelf.userService.setLocalUserWithFirebaseId(name: "", email: strongSelf.emailTxt.text!, profileUrl: "")
                
                self?.setRootViewController(name: "MainTabBar")
            }

        }
        
    }
    
    func validateEmailAndPassword() {
        
        guard let email = emailTxt.text, email != "" ,
            Validator.isValidEmail(email) else {
            print("email is empty")
                UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: false)
            return
        }
        
        UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: true)
        
        guard let password = passwordTxt.text, password != "" else {
            print("password is empty")
            UIViewUtils.setUnsetError(of: passwordTxt, forValidStatus: false)
            return
        }
        
        UIViewUtils.setUnsetError(of: passwordTxt, forValidStatus: true)
        
        print("email: \(email)")
    
    }
    
    @IBAction func viewAsGuestAction(_ sender: UIButton) {
        UserMode.isAnonymous = true
        self.setRootViewController(name: "MainTabBar")
    }

}
