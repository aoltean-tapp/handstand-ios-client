import UIKit

protocol HSTileLocationCellProtocol:class {
    func showLocationEnable()
}

class HSTileLocationCell: HSBaseTableViewCell {

    public weak var delegate:HSTileLocationCellProtocol?
    
    @IBOutlet var locationButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        HSAnalytics.setEventForTypes(withLog: HSA.locationPermissionScreen)
    }

    public override func populateData() {
       locationButton.addTarget(self, action:#selector(self.showLocationEnable) , for: .touchUpInside)
    }
    @objc func showLocationEnable() {
        self.delegate?.showLocationEnable()
    }
}
