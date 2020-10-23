import UIKit

class UserViewController: BaseViewController {

    public var userToken:String!
    public var user: User!
    
    /* Views */
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileUrl: UILabel!
    @IBOutlet weak var facebookProfileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup container ScrollView
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: facebookProfileView.frame.origin.y + 250)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;

        if let token = userToken {
            userService.getUser(token: userToken) {
                (user: User?) in
                if let postUser = user {
                    self.user = user
                    
                    self.name.text = postUser.name
                    self.email.text = postUser.email
                    self.profileUrl.text = postUser.profileUrl
                    
                    // load photo from url
                    if postUser.photoUrl != "" {
                        let profileUrl = URL(string: postUser.photoUrl)
                        self.profileImage.kf.setImage(with: profileUrl)
                    }
                    
                    print(user)
                }
            }
        }
        
    }
    
    @IBAction func facebookProfileAction(_ sender: Any) {
        if user.profileUrl != "" {
            let profileUrl = URL(string: user.profileUrl)
            UIApplication.shared.openURL(profileUrl!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
