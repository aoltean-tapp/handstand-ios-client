import UIKit

class HSTileBlogCell: HSBaseTableViewCell {
    @IBOutlet weak var markerTag: UIImageView! {
        didSet {
            markerTag.applyTintAttribute()
        }
    }
}
