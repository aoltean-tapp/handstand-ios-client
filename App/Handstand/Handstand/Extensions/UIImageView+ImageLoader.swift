import UIKit
import SDWebImage

enum ImageStyle:Int {
    case squared
    case rounded
}

extension UIImageView {
    
    func setImage(url:String,style:ImageStyle = .rounded) {
        self.image = nil
        
        if url.count < 1 {
            return
        }
        self.backgroundColor = UIColor.rgb(0xEDF0F1)
        
        if(style == .rounded) {
            self.layer.cornerRadius = self.frame.height/2
            self.layer.borderWidth = 3.0
            self.layer.borderColor = UIColor.white.cgColor
        }
        else if(style == .squared){
            self.layer.cornerRadius = 3.0
        }
        self.setShowActivityIndicator(true)
        self.setIndicatorStyle(.gray)
        
        if SDWebImageManager.shared().cachedImageExists(for: URL.init(string: url)) {
            self.backgroundColor = .clear
            self.sd_setImage(with: URL.init(string: url))
            self.clipsToBounds = true
        }
        else {
            self.sd_setImage(with: URL.init(string: url), placeholderImage:nil, options: [.avoidAutoSetImage,.highPriority,.retryFailed,.delayPlaceholder], completed: { (image, error, cacheType, url) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.backgroundColor = .clear
                        self.alpha = 0;
                        self.image = image
                        self.clipsToBounds = true
                        UIView.animate(withDuration: 0.5, animations: {
                            self.alpha = 1
                        })
                    }
                }
            })
        }
    }
}


