import UIKit

protocol HSTileUpcomingSessionCellProtocol:class {
    func didTapContactContactTrainerViaMessage(number:String)
    func didTapContactContactTrainerViaPhone(number:String)
}

extension UIImageView {
    func applyTintAttribute() {
        let image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = HSColorUtility.markerTagColor()
        self.image = image
    }
}

class HSTileUpcomingSessionCell: HSBaseTableViewCell {
    
    public weak var delegate:HSTileUpcomingSessionCellProtocol?
    
    @IBOutlet weak var didTapMsgButton: UIButton!
    @IBOutlet weak var didTapCallButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var trainerImageView: HSRoundedView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var markerTag: UIImageView! {
        didSet {
            markerTag.applyTintAttribute()
        }
    }
    
    public override func populateData() {
        if let session = HSAppManager.shared.upcomingSession {
            locationLabel.text = session.formatted_location
            classLabel.text = session.speciality
            trainerImageView.imageView.sd_setImage(with: URL(string: (session.thumbnail)!))
            timeLabel.text = (session.startTime)!
            headerLabel.text = "You have a session with \(session.first_name!) " + ((session.startDate as! NSDate).timeFromNow())+"!"
        }
    }
    @IBAction func didTapMsgButton(_ sender: Any) {
        let session = HSAppManager.shared.upcomingSession
        self.delegate?.didTapContactContactTrainerViaMessage(number: (session?.mobile)!)
    }
    
    @IBAction func didTapPhoneButton(_ sender: Any) {
        let session = HSAppManager.shared.upcomingSession
        self.delegate?.didTapContactContactTrainerViaPhone(number: (session?.mobile)!)
    }
    
}
