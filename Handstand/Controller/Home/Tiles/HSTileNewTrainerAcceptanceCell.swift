import UIKit

protocol HSTileNewTrainerAcceptanceCellProtocol:class {
    func didTapContactContactTrainerViaMessage(number:String)
    func didTapContactContactTrainerViaPhone(number:String)
    func didTapRejectNewTrainerRequest()
    func didTapConfirmNewTrainerRequest()
    func didTapOldTrainerBookButton()
//    func didTapContactViaEmail(email:String)
}

class HSTileNewTrainerAcceptanceCell: HSBaseTableViewCell {
    
    public weak var delegate:HSTileNewTrainerAcceptanceCellProtocol?
    
    @IBOutlet weak var _newTrainerProfileRoundedView: HSRoundedView!
    @IBOutlet weak var _oldTrainerProfileRoundedView: HSRoundedView! {
        didSet {
            _oldTrainerProfileRoundedView.alpha = 0.5
        }
    }
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var classTypeLabel: UILabel!
    @IBOutlet fileprivate weak var startsAtLabel: UILabel!
    @IBOutlet weak var phoneContactButton: UIButton!
    @IBOutlet weak var messageContactButton: UIButton!
    @IBOutlet weak var rejectButton: HSButton! {
        didSet {
            rejectButton.btnType = .typeC
        }
    }
    @IBOutlet weak var confirmButton: HSButton! {
        didSet {
            confirmButton.btnType = .typeD
        }
    }
    
    @IBOutlet weak var originalTrainerImageView: HSRoundedView!
    @IBOutlet weak var originalTrainerNameLabel: UILabel!
    @IBOutlet weak var originalTrainerBookButton: UIButton!
    @IBOutlet weak var markerTag: UIImageView! {
        didSet {
                markerTag.applyTintAttribute(with:  HSAppManager.shared.declinedRequest?.originalTrainerDetails?.color)
        }
    }

    @IBOutlet weak var orFindAnotherTrainerLabel: UILabel!

    public override func populateData() {
        let originalTrainerDetails = HSAppManager.shared.declinedRequest?.originalTrainerDetails
        if let declinedRequest = HSAppManager.shared.declinedRequest {
            _newTrainerProfileRoundedView.imageView.setImage(url: (declinedRequest.avatar)!, style: .rounded)
            _newTrainerProfileRoundedView.backgroundColor = HSColorUtility.getMarkerTagColor(with: declinedRequest.color)

            _oldTrainerProfileRoundedView.imageView.setImage(url: (originalTrainerDetails?.trainerAvatar)!)
            _oldTrainerProfileRoundedView.backgroundColor = HSColorUtility.getMarkerTagColor(with: originalTrainerDetails?.color)

            classTypeLabel.text = declinedRequest.speciality
            startsAtLabel.text = declinedRequest.finalSessionTime
            let captionText = "Your trainer couldn't make it. But another top trainer is ready to go." + " " + declinedRequest.firstName! + "!"
            captionLabel.text = captionText
        }
        originalTrainerImageView.imageView.setImage(url: (originalTrainerDetails?.trainerAvatar)!)
        originalTrainerImageView.backgroundColor = HSColorUtility.getMarkerTagColor(with: originalTrainerDetails?.color)
        originalTrainerNameLabel.text = originalTrainerDetails?.trainerFirstname
        orFindAnotherTrainerLabel.text = "Or find another time with" + " " + (originalTrainerDetails?.trainerFirstname)!
    }
    
    //MARK: - Button Actions
    @IBAction func didTapMsgButton(_ sender: Any) {
        if let declinedRequest = HSAppManager.shared.declinedRequest {
            let phoneNumber = declinedRequest.mobile
            self.delegate?.didTapContactContactTrainerViaMessage(number: phoneNumber!)
        }
    }
    
    @IBAction func didTapPhoneButton(_ sender: Any) {
        if let declinedRequest = HSAppManager.shared.declinedRequest {
            let phoneNumber = declinedRequest.mobile
            self.delegate?.didTapContactContactTrainerViaPhone(number: phoneNumber!)
        }
    }
    
    @IBAction func didTapRejectButton(_ sender: Any) {
        self.delegate?.didTapRejectNewTrainerRequest()
    }
    
    @IBAction func didTapConfirmButton(_ sender: Any) {
//        self.delegate?.didTapConfirmNewTrainerRequest()
        if let declinedRequest = HSAppManager.shared.declinedRequest {
            let phoneNumber = declinedRequest.mobile
            self.delegate?.didTapContactContactTrainerViaPhone(number: phoneNumber!)
        }
    }
    
    @IBAction func didTapBookOriginalTrainer(_ sender: Any) {
        self.delegate?.didTapOldTrainerBookButton()
    }
    
}
