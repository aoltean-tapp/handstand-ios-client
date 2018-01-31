import UIKit

class HSTilesTitleCell: HSBaseTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        HSAnalytics.setEventForTypes(withLog: HSA.welcomeTileClick)
    }
    
   public override func populateData() {
        if let fname = HSUserManager.shared.currentUser?.firstname {
            titleLabel.text = "Welcome back, \(fname.capitalized)"
        }else {
            titleLabel.text = "Welcome back"
        }
    }
}
