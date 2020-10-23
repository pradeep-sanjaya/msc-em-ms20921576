import UIKit

@IBDesignable
public class CornerButton: UIButton {
       
    @IBInspectable
    var topLeftCorner:Bool = false;
    
    @IBInspectable
    var topRightCorner:Bool = false;
    
    @IBInspectable
    var bottomLeftCorner:Bool = false;
    
    @IBInspectable
    var bottomRightCorner:Bool = false;
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var corners: UIRectCorner = UIRectCorner()
        
        if self.topLeftCorner == true {
            corners.insert(.topLeft)
        }

        if self.topRightCorner == true {
            corners.insert(.topRight)
        }

        if self.bottomLeftCorner == true {
            corners.insert(.bottomLeft)
        }

        if self.bottomRightCorner == true {
            corners.insert(.bottomRight)
        }
        
        self.roundCorners(corners, radius: self.cornerRadius)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}
