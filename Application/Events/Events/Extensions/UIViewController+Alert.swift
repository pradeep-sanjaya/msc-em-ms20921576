import UIKit

extension UIViewController {

    func presentAlert(withTitle title: String, message : String, actions : [String: UIAlertAction.Style], completionHandler: ((UIAlertAction) -> ())? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for action in actions {
            let action = UIAlertAction(title: action.key, style: action.value) { action in
                if completionHandler != nil {
                    completionHandler!(action)
                }
            }
            alert.addAction(action)
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    public func presentHideAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

/*
 usage
 1.)
 self.presentAlert(withTitle: "Mail services are not available", message: "Please Configure Mail On This Device", actions: ["OK" : .default] , completionHandler: nil)

 2.)
 self.presentAlert(withTitle: "Network Error", message: "Please check your internet connection", actions: [
     "Retry" : .default, "Cancel": .destructive] , completionHandler: {(action) in

         if action.title == "Retry" {
             print("tapped on Retry")

         }else if action.title == "Cancel" {
             print("tapped on Cancel")
         }
 })
 
 */
