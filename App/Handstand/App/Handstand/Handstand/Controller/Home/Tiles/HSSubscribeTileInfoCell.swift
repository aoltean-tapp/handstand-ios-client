import UIKit

protocol HSSubscribeTileInfoCellProtocol:class {
    func didTapViewBenefitsBtn()
}

class HSSubscribeTileInfoCell: HSBaseTableViewCell {

    public weak var delegate:HSSubscribeTileInfoCellProtocol?
    
    @IBOutlet public weak var viewBenefitsBtn: UIButton!
    @IBOutlet weak var listInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Display.typeIsLike == .iphone4 || Display.typeIsLike == .iphone5 {
            listInfoLabel.font = listInfoLabel.font.withSize(14)
        }
    }
    override func populateData() {
        viewBenefitsBtn.addTarget(self, action:#selector(self.didTapViewBenefitsBtn) , for: .touchUpInside)
    }
    
    @objc func didTapViewBenefitsBtn() {
        self.delegate?.didTapViewBenefitsBtn()
    }
}
