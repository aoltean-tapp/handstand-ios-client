import UIKit

protocol HSTileVideoCellProtocol:class {
    func onVideoAction()
}

class HSTileVideoCell: HSBaseTableViewCell {

    public weak var delegate:HSTileVideoCellProtocol?
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var subTitleTopSpaceLC: NSLayoutConstraint!
    @IBOutlet weak var markerTag: UIImageView! {
        didSet {
            markerTag.applyTintAttribute()
        }
    }
    public override func populateData() {
//        videoButton.addTarget(self, action:#selector(self.onVideoAction) , for: .touchUpInside)
        if let currentVideo = HSAppManager.shared.videoSession?.dailyVideo {
            titleLabel.text =  "Today's Video: "+currentVideo.title!
            if let classType = currentVideo.classType {
                subTitleLabel.text = classType
            }
            if let url = currentVideo.thumbnail {
                bgImage.sd_setImage(with: URL(string: url))
            }
            subTitleTopSpaceLC.constant = 0
        }else {
            titleLabel.text = "Not Available"
            subTitleTopSpaceLC.constant = 0
        }
        self.layoutIfNeeded()
    }
    
    @objc func onVideoAction() {
        self.delegate?.onVideoAction()
    }
    
}
