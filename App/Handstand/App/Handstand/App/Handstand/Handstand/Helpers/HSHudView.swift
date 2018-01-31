import UIKit

class HSHudView: UIView {
    public var lblErrorMessage: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        lblErrorMessage = UILabel()
        lblErrorMessage?.textAlignment = .center
        lblErrorMessage?.textColor = .white
        lblErrorMessage?.font = HSFontUtilities.avenirNextRegular(size: 12)
        addSubview(self.lblErrorMessage!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblErrorMessage?.frame = self.bounds
    }
    
}
