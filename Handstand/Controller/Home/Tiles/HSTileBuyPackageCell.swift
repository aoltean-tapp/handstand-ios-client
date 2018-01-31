import UIKit

protocol HSTileBuyPackageCellProtocol:class {
    func showBuyPackage()
}

class HSTileBuyPackageCell: HSBaseTableViewCell {
    public weak var delegate:HSTileBuyPackageCellProtocol?
    
    @IBOutlet var buyButton: UIButton!
    override func populateData() {
        buyButton.addTarget(self, action:#selector(self.showBuyPackage) , for: .touchUpInside)
    }
    
    @objc func showBuyPackage() {
        self.delegate?.showBuyPackage()
    }
}
