import UIKit

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let sizeX = (bounds.width - size.width) / 2.0
        let sizeY = (bounds.height - size.height) / 2.0
        
        return CGRect(x: sizeX, y: sizeY, width: size.width, height: size.height)
    }
}
