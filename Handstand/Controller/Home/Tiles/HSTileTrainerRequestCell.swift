import UIKit

protocol HSTileTrainerRequestCellProtocol:class {
    func onConfirmAction()
    func onRejectAction()
}

class HSTileTrainerRequestCell: HSBaseTableViewCell {

    public weak var delegate:HSTileTrainerRequestCellProtocol?
    
    @IBOutlet var confirmButton: HSButton! {
        didSet {
            confirmButton.btnType = .typeD
        }
    }
    @IBOutlet var rejectButton: HSButton! {
        didSet {
            rejectButton.btnType = .typeC
        }
    }
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var specialityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var trainerImageView: HSRoundedView!
    @IBOutlet weak var markerTag: UIImageView! {
        didSet {
                markerTag.applyTintAttribute(with: HSAppManager.shared.trainerRequest?.color)
        }
    }
    
   public override func populateData() {
        if let trainRequest = HSAppManager.shared.trainerRequest {
            locationLabel.text = trainRequest.formattedLocation
            trainerImageView.imageView.sd_setImage(with: URL(string: (trainRequest.thumbnail)!))
            trainerImageView.backgroundColor = HSColorUtility.getMarkerTagColor(with: trainRequest.color)

            specialityLabel.text = trainRequest.speciality
            timeLabel.text = trainRequest.startTime
            headerLabel.text = (trainRequest.partialTrainerName())+" "+"has booked a session with you for"+" "+((trainRequest.startDate as! NSDate).timeFromNow()) + "!"
            confirmButton.addTarget(self, action:#selector(self.onConfirmAction) , for: .touchUpInside)
            rejectButton.addTarget(self, action:#selector(self.onRejectAction) , for: .touchUpInside)
        }
    }
    
    @objc func onConfirmAction() {
        self.delegate?.onConfirmAction()
    }
    @objc func onRejectAction() {
        self.delegate?.onRejectAction()
    }
    
}
