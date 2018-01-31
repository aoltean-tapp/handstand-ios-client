protocol promoCodeAdder {
    func didApplyPromo(code:String,response:HSPromoResponse)
}
class HSPromotionController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet private var successView: UIView!
    @IBOutlet private var successMessageLabel: UILabel!
    @IBOutlet private var successTitleLabel: UILabel!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var codeTextfield: HSValidationTextfield!
    public var delegate:promoCodeAdder?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Promotion"
        self.screenName = HSA.promoCodeScreen
        codeTextfield.textfield.textfield.autocapitalizationType = .allCharacters
        codeTextfield.textfield.textfield.autocorrectionType = .no
    }
    
    //MARK:- MISC
    private func isAllValid() -> Bool {
        var flag = false
        if (codeTextfield.text()?.count)! > 0 {
            flag = true
        }else{
            showErrorMessage(NSLocalizedString("Promo_Err", comment: ""))
        }
        return flag
    }
    
    private  func showErrorMessage(_ message : String)  {
        codeTextfield.setErrorMessage(message)
        errorLabel.text = "* " + message
        errorLabel.isHidden = false
    }
    
    fileprivate func clearErrorMessage()  {
        errorLabel.isHidden = true
    }
    
    private func showSuccessMessage(_ message : String){
        successView.alpha = 1.0
        successTitleLabel.text = NSLocalizedString("Promo_Msg", comment: "").replacingOccurrences(of: "CODEHERE", with: (codeTextfield.text()?.uppercased())!)
        successMessageLabel.text = message
        codeTextfield.setText("")
    }
    
    //MARK:- Button Action
    @IBAction private func onApplyAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllValid() {
            sender.startLoading()
            HSUserNetworkHandler().applyPromoCode(codeTextfield.text()!, onComplete: { (promoResponse, error) in
                sender.stopLoading()
                if error == nil {
                    HSAnalytics.setEventForTypes(withLog: HSA.promoCodeAdded)
                    self.delegate?.didApplyPromo(code:self.codeTextfield.text()!, response: promoResponse!)
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.showErrorMessage((error?.message!)!)
                }
            })
        }
    }
    
    @IBAction private func onCloseAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.successView.alpha = 0.0
        })
    }
}

//MARK: - Extension|HSValidationTextfieldDelegate
extension HSPromotionController:HSValidationTextfieldDelegate {
    
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        return true
    }
    
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool{
        return true
    }
}
