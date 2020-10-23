import UIKit

class UIViewUtils {
    static func setUnsetError(of control: UIView, forValidStatus status: Bool) {
        if (status == false) {
            control.layer.borderColor = UIColor.red.cgColor //UIColor(named: "Red")?.cgColor
        } else {
            control.layer.borderColor = UIColor(named: "DarkBlue")?.cgColor
        }
    }

}
