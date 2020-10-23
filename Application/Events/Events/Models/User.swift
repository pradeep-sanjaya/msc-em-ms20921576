import Foundation

enum AuthType: String {
    case firebase
    case facebook
    case other
    
    func toString() -> String {
        switch self {
            case AuthType.firebase:
                return "firebase"
            case AuthType.facebook:
                return "facebook"
            default:
                return "other"
        }
    }
    
    static func getAuthTypeByString(value: String?) -> AuthType {
        var type = AuthType.other
        
        guard value != nil else {
            return type
        }
        
        switch value {
            case AuthType.firebase.rawValue:
                type = AuthType.firebase
            
            case AuthType.facebook.rawValue:
                type = AuthType.facebook
            
            default:
                break
        }
        
        return type
    }
}

struct User {
    var type: AuthType;
    var token: String;
    var name: String;
    var email: String;
    var profileUrl: String;
    var photoUrl: String;
}
