import UIKit

protocol HSTilePushNotificationCellProtocol:class {
    func onClickPushNotificationEnable()
}

class HSTilePushNotificationCell: HSBaseTableViewCell {

    public weak var delegate:HSTilePushNotificationCellProtocol?
    
    @IBOutlet weak var pushNotificationEnableBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        HSAnalytics.setEventForTypes(withLog: HSA.pushPermissionScreen)
    }
    
    override func populateData() {
        pushNotificationEnableBtn.addTarget(self, action:#selector(self.onClickPushNotificationEnable) , for: .touchUpInside)
    }
    @objc func onClickPushNotificationEnable() {
        self.delegate?.onClickPushNotificationEnable()
    }
}
