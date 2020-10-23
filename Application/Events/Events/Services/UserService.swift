import Foundation
import Firebase
import FacebookLogin

class UserService {
    
    let defaults = UserDefaults.standard
    let rootRef = Database.database().reference()

    // firebase auth
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil) {
          Auth.auth().createUser(withEmail: email, password: password) {
            
            (user, error) in
              if let e = error {
                  callback?(e)
                  return
              }
              callback?(nil)
          }
    }
    
    func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let e = error {
                callback?(e)
                return
            }
            
            callback?(nil)
        }
    }
    
    func sendEmailVerification(_ callback: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            callback?(error)
        })
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    func isSgined() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        
        return false
    }
    
    func getFirebaseUserId() -> String? {

        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not signed in")
            return nil
        }
        
        return userId
    }
    
    func signOutFirebase() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func updateProfileInfo(withImage image: Data? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil) {
        
        guard let user = Auth.auth().currentUser else {
            callback?(nil)
            return
        }

        if let image = image {
            let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).png")

            _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
                if let error = error {
                    callback?(error)
                } else {
                    profileImgReference.downloadURL(completion: { (url, error) in
                        if let url = url{
                            self.createProfileChangeRequest(photoUrl: url, name: name, { (error) in
                                callback?(error)
                            })
                        }else{
                            callback?(error)
                        }
                    })
                }
            }
        } else if let name = name {
            self.createProfileChangeRequest(name: name, { (error) in
                callback?(error)
            })
        } else {
            callback?(nil)
        }
    }
    
    func createProfileChangeRequest(photoUrl: URL? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil) {
        
        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
            if let name = name {
                request.displayName = name
            }
            
            if let url = photoUrl {
                request.photoURL = url
            }

            request.commitChanges(completion: { (error) in
                callback?(error)
            })
        }
    }
    
    // facebook
    func signOutFacebook() -> Bool {
        let loginManager = LoginManager()
        loginManager.logOut()
        return true
    }
    
    
    // user default
    public func getLocalUser() -> User {
        
        let userDictonary = defaults.object(forKey: "user") as? [String:String] ?? [String:String]()

        if let type = userDictonary["type"] {
            let authType = AuthType.getAuthTypeByString(value: type)

            return User(
                type: authType,
                token: userDictonary["token"] ?? "",
                name: userDictonary["name"] ?? "",
                email: userDictonary["email"] ?? "",
                profileUrl: userDictonary["profileUrl"] ?? "",
                photoUrl: userDictonary["photoUrl"] ?? ""
            )
        }
        
        return User(type: AuthType.other, token: "", name: "", email: "", profileUrl: "", photoUrl: "")

    }

    public func setLocalUser(user: User) {
        let userDictonary = [
            "type": user.type.toString(),
            "token": user.token,
            "name": user.name,
            "email": user.email,
            "profileUrl": user.profileUrl,
            "photoUrl": user.photoUrl
        ]
        
        defaults.set(userDictonary, forKey: "user")
    }
    
    public func setLocalUserWithFirebaseId(name: String, email: String, profileUrl: String) {
        
        print("--- setLocalUserWithFirebaseId ---")
            
        guard let userId = self.getFirebaseUserId() else {
            return
        }

        var user = User(
            type: AuthType.firebase,
            token: userId,
            name: name,
            email: email,
            profileUrl: "",
            photoUrl: ""
        )
        
        getUser(token: userId) {
            firebaseUser in
            
            if let fireUser = firebaseUser {
                user.name = fireUser.name
                user.profileUrl = fireUser.profileUrl
                user.photoUrl = fireUser.photoUrl
            }
            
            self.setLocalUser(user: user)
            
            print("user: \(user)")
        }
        
    }
    
    public func signOut() {
        let _ = signOutFirebase()
        let _ = signOutFacebook()
        defaults.removeObject(forKey:"user")
    }

    // firebase database
    
    public func saveUser(user: User) {
        
        setLocalUser(user: user)
        
        let userRef = self.rootRef.child(COLLECTION_USERS)
                
        let firebaseUser: [String: String] = [
            USER_AUTH_TYPE: user.type.toString(),
            USER_TOKEN: user.token,
            USER_NAME: user.name,
            USER_EMAIL: user.email,
            USER_PROFILE: user.profileUrl,
            USER_PHOTO: user.photoUrl
        ]

        userRef.child(user.token).setValue(firebaseUser) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print(ref)
            print("Data saved successfully!")
          }
        }
    }
    
    public func getUser(token: String, callback: @escaping (User?) -> Void) -> Void {
        
        let userRef = self.rootRef.child(COLLECTION_USERS)
        
        userRef.child(token).observe(DataEventType.value, with: {
            (snapshot) in
            let userDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            let authType   = userDict[USER_AUTH_TYPE] as? String ?? ""
            let name       = userDict[USER_NAME] as? String ?? ""
            let email      = userDict[USER_EMAIL] as? String ?? ""
            let profileUrl = userDict[USER_PROFILE] as? String ?? ""
            let photoUrl   = userDict[USER_PHOTO] as? String ?? ""

            let user = User(
                type: AuthType.getAuthTypeByString(value: authType),
                token: token,
                name: name,
                email: email,
                profileUrl: profileUrl,
                photoUrl: photoUrl
            )
            
            callback(user)
        })
        
        callback(nil);
    }
}
