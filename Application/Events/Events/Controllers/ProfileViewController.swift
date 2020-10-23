import UIKit
import MessageUI
import Firebase

class ProfileViewController: BaseViewController,
    MFMailComposeViewControllerDelegate,
    UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var fullNameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet weak var facebookProfileTxt: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    /* Variables */
    var imagePicker: ImagePicker!
    var localUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Profile"
        
        // Setup container ScrollView
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: logoutButton.frame.origin.y + 250)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        let user = userService.getLocalUser()

        self.localUser = user
        print("local user: \(self.localUser)")
        
        fullNameTxt.text = self.localUser.name
        emailTxt.text = self.localUser.email
        facebookProfileTxt.text = self.localUser.profileUrl
        
        // get event image
        if self.localUser.photoUrl != "" {
            let url = URL(string: self.localUser.photoUrl)
            profileImage.kf.setImage(with: url)
        }
        
    }
    
    
    
    // MARK - Textfields deligate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTxt  {
            emailTxt.becomeFirstResponder()
        }
    
        if textField == emailTxt  {
            facebookProfileTxt.becomeFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: - Dismiss keyboard
    @IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        fullNameTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
        facebookProfileTxt.resignFirstResponder()
    }
    
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    // MARK: - Update profile
    @IBAction func updateProfileAction(_ sender: UIButton) {
        dismissKeyboard()
        
        print("----- updateProfileAction -----")
        
        if validate() {
        
            let localUser = userService.getLocalUser()
            print("local user: \(localUser)")
        
            var photoUrl = localUser.photoUrl
        
            var user = User(
                type: localUser.type,
                token: localUser.token,
                name: fullNameTxt.text!,
                email: emailTxt.text!,
                profileUrl: self.facebookProfileTxt.text!,
                photoUrl: localUser.photoUrl
            )
        
            if let image = self.profileImage.image {
                
                print("should update user prifile with new image")
                
                storageService.uploadUserProfile(image: image, token: localUser.token) {
                    (isSuccess, url) in
                    photoUrl = url!
                    
                    user.photoUrl = photoUrl
                    
                    self.userService.setLocalUser(user: user)
                    self.userService.saveUser(user: user)
                }
            } else {
                self.userService.setLocalUser(user: user)
                self.userService.saveUser(user: user)
            }
        
            self.presentHideAlert(withTitle: Bundle.appName(), message: "Profile updated successfully.")

        } else {
            self.presentHideAlert(withTitle: Bundle.appName(), message: "Name or email is empty")
            return
        }
        
                
//        // This string containes standard HTML tags, you can edit them as you wish
//        let messageStr = "<font size = '1' color= '#222222' style = 'font-family: 'HelveticaNeue'>\(messageTxt!.text!)<br><br>You can reply to: \(emailTxt!.text!)</font>"
//        
//        let mailComposer = MFMailComposeViewController()
//        mailComposer.mailComposeDelegate = self
//        mailComposer.setSubject("Message from \(fullNameTxt!.text!)")
//        mailComposer.setMessageBody(messageStr, isHTML: true)
//        mailComposer.setToRecipients([CONTACT_EMAIL_ADDRESS])
//        
//        if MFMailComposeViewController.canSendMail() {
//            present(mailComposer, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertView(title: APP_NAME,
//                                    message: "Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.",
//                                    delegate: nil,
//                                    cancelButtonTitle: "OK")
//            alert.show()
//        }
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        userService.signOut()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController
        
        UIApplication.shared.windows.first?.rootViewController = mainNavigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    
    func validate() -> Bool {
        
        guard let name = fullNameTxt.text, name != "" else {
            print("Name is not valid")
                UIViewUtils.setUnsetError(of: fullNameTxt, forValidStatus: false)
            return false
        }
        
        UIViewUtils.setUnsetError(of: fullNameTxt, forValidStatus: true)
        
        guard let email = emailTxt.text,
            email != "",
            Validator.isValidEmail(email) else {
            print("email is not valid")
            UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: false)
            return false
        }
        
        UIViewUtils.setUnsetError(of: emailTxt, forValidStatus: true)
            
        return true
    }
    
    // Email delegate
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        
        var resultMess = ""
        switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                resultMess = "Mail cancelled"
            case MFMailComposeResult.saved.rawValue:
                resultMess = "Mail saved"
            case MFMailComposeResult.sent.rawValue:
                resultMess = "Thanks for contacting us!\nWe'll get back to you asap."
            case MFMailComposeResult.failed.rawValue:
                resultMess = "Something went wrong with sending Mail, try again later."
            default:break
        }
        
        simpleAlert(resultMess)
        
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}
