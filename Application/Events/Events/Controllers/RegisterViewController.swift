import UIKit
import Firebase

class RegisterViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordRetypeTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func prepareUIControls() {
        preparePassword()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func preparePassword() {
        passwordTxt.layer.borderWidth = 1
        passwordTxt.layer.borderColor = UIColor.init(named: "DarkBlue")?.cgColor
        add(image: UIImage(named: "Eye")!, toTextField: passwordTxt)
        
        //let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 40))
        //passwordRetypeTxt.leftView = paddingView
        passwordRetypeTxt.leftViewMode = .always
        passwordRetypeTxt.layer.borderWidth = 1
        passwordRetypeTxt.layer.borderColor = UIColor.init(named: "DarkBlue")?.cgColor
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
        passwordTxt.isSecureTextEntry.toggle()
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        
        if validate() {
            userService.createUser(email: emailTxt.text!, password: passwordTxt.text!) {
                (error) in
                
                if error == nil {
                    self.userService.login(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!)
                    
                    self.userService.setLocalUserWithFirebaseId(name: self.nameTxt.text!, email: self.emailTxt.text!, profileUrl: "")
                    
                    let user = self.userService.getLocalUser()
                    self.userService.saveUser(user: user)
                    
                    self.setRootViewController(name: "MainTabBar")
                } else {
                    self.presentHideAlert(withTitle: Bundle.appName(), message: "An error occurred. ")
                }
            }
        }

    }
    
    func validate() -> Bool {
        guard let name = nameTxt.text, name != "" else {
            print("name is empty")
            UIViewUtils.setUnsetError(of: nameTxt, forValidStatus: false)
            nameTxt.becomeFirstResponder()
            return false
        }
        
        UIViewUtils.setUnsetError(of: nameTxt, forValidStatus: true)
        
        guard let email = emailTxt.text, email != "", Validator.isValidEmail(email) else {
            print("email is empty")
            UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: false)
            emailTxt.becomeFirstResponder()
            return false
        }
        
        UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: true)
        
        guard let password = passwordTxt.text, password != "" else {
            print("password is empty")
            UIViewUtils.setUnsetError(of: passwordTxt, forValidStatus: false)
            passwordTxt.becomeFirstResponder()
            return false
        }
        
        UIViewUtils.setUnsetError(of: passwordTxt, forValidStatus: true)
        
        guard let passwordRetype = passwordRetypeTxt.text,
            passwordRetype != "",
            password == passwordRetype else {
            print("retype password is empty")
            UIViewUtils.setUnsetError(of: passwordRetypeTxt, forValidStatus: false)
            passwordRetypeTxt.becomeFirstResponder()
            return false
        }
        
        UIViewUtils.setUnsetError(of: passwordRetypeTxt, forValidStatus: true)
        
        return true
    }
    
    @objc func navigationBackButton(_ sender: UIBarButtonItem) {
    }

}
