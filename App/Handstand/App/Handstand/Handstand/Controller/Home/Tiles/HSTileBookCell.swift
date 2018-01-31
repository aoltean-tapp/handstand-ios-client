import UIKit

protocol HSTileBookCellProtocol:class {
    func showBookSession()
}

class HSTileBookCell: HSBaseTableViewCell {

    public weak var delegate:HSTileBookCellProtocol?
    
    @IBOutlet var bookButton: UIButton!
    
    public override func populateData() {
        bookButton.addTarget(self, action:#selector(self.showBookSession) , for: .touchUpInside)
    }
    
    @objc func showBookSession() {
        self.delegate?.showBookSession()
    }
   
}
