import SDWebImage

extension UIImageView {
    public typealias Completion = (UIImage?) -> Void
    
    public func downloadImage(at url: URL?, placeholderImage: UIImage, complition: Completion? = nil) {
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { (image, error, cache, url) in
            if image != nil && cache == .none {
                self.alpha = 0
                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                    self.image = image
                    self.alpha = 1
                }, completion: nil)
            }
            else {
                self.alpha = 1
            }
            
            complition?(image)
        }
    }
    
    public func fadeImageDownload(at url: URL?, placeholderImage: UIImage) {
        sd_setImage(with: url, placeholderImage: placeholderImage, options: []) { (image, error, cache, url) in
            self.alpha = 0
            
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                self.image = image
                self.alpha = 1
            }, completion: nil)
        }
    }
}

