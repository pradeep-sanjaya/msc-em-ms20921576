import UIKit

class MainNavigationBar: UINavigationBar, UINavigationBarDelegate {

    override func popItem(animated: Bool) -> UINavigationItem? {
         return super.popItem(animated: false)
     }

}
