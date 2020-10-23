import UIKit

@IBDesignable
public class CornerTextField: UITextField {
    
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
        
        var corners: CACornerMask = CACornerMask()
        
        if self.topLeftCorner == true {
            corners.insert(.layerMinXMinYCorner)
        }
        
        if self.topRightCorner == true {
            corners.insert(.layerMaxXMinYCorner)
        }
        
        if self.bottomLeftCorner == true {
            corners.insert(.layerMinXMaxYCorner)
        }
        
        if self.bottomRightCorner == true {
            corners.insert(.layerMaxXMaxYCorner)
        }
        
        self.roundCorners(corners, radius: self.cornerRadius)
        self.setPlaceholderColor()
        self.setColor()
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = corners
    }
    
    func setPlaceholderColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "LightBlue") ?? UIColor.lightGray])
    }
    
    func setColor() {
        self.textColor = UIColor.init(named: "Black")
    }
    
    struct Constants {
        static let sidePadding: CGFloat = 10
        static let topPadding: CGFloat = 8
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
