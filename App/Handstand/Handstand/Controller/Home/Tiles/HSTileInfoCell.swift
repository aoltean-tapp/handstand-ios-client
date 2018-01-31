import UIKit

class HSTileInfoCell: HSBaseTableViewCell {

    @IBOutlet weak var listInfoLabel: UILabel!
    @IBOutlet var bottomInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        if Display.typeIsLike == .iphone4 || Display.typeIsLike == .iphone5 {
            bottomInfoLabel.font = bottomInfoLabel.font.withSize(16)
            listInfoLabel.font = listInfoLabel.font.withSize(14)
        }
    }

}
