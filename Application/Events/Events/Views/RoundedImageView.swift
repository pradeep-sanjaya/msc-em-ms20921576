import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.init(named: "Black")!.cgColor
        frame.size.width = frame.size.height
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = true
        layer.zPosition = -500;
    }
    
}
