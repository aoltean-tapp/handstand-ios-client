//
//  HSQuizStyleResultController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSQuizStyleResultController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var paragraphTextView: UITextView!
    @IBOutlet weak var shadowView: UIView! {
        didSet { shadowView.dropShadow() }
    }
    @IBOutlet weak var goButton: UIButton! {
        didSet { goButton.layer.cornerRadius = 4 }
    }
    @IBOutlet weak var heartRateImageView: UIImageView!
    @IBOutlet weak var quizBackgroundImageView: UIImageView!
    public var handpickedQuiz:HSQuizPostResponse?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self, titleView: getTitleView())
        populateHandPickedQuizData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    @IBAction func didTapGoNGo(_ sender: Any){
        HSLoadingView.standardLoading().startLoading()
        HSApp().getAppFirstController({ (viewcontroller) in
            HSAnalytics.setMixpanelPeopleConfiguration(HSUserManager.shared.currentUser!)
            HSAnalytics.setEventForTypes(withLog: HSA.createdAccount)
            HSLoadingView.standardLoading().stopLoading()
            appDelegate.window?.rootViewController = viewcontroller
        })
    }
    
    //MARK: - Private functions
    private func populateHandPickedQuizData() {
        if let quizData = handpickedQuiz {
            if let code = quizData.data?.color {
                let colorRecieved =  HSColorUtility.getMarkerTagColor(with: code)

                let heartRateImage = heartRateImageView?.image?.withRenderingMode(.alwaysTemplate)
                self.heartRateImageView.tintColor = colorRecieved
                self.heartRateImageView.image = heartRateImage

                self.goButton.backgroundColor = colorRecieved
                
                let quizBgImage = quizBackgroundImageView.image?.withRenderingMode(.alwaysTemplate)
                self.quizBackgroundImageView.tintColor = colorRecieved
                self.quizBackgroundImageView.image = quizBgImage
                
                let unStyledHeaderText = "YOU'RE A "+(quizData.data?.styleText ?? "")+" IN HANDSTAND!"
                let attrs = [NSForegroundColorAttributeName:UIColor.black]
                let attrStr:NSMutableAttributedString = NSMutableAttributedString(string: unStyledHeaderText, attributes: attrs)
                attrStr.addAttribute(NSForegroundColorAttributeName,
                                     value: colorRecieved,
                                     range: NSRange.init(location: "YOU'RE A ".count, length: (quizData.data?.styleText ?? "").count))
                self.topLabel.attributedText = attrStr
            }
            self.paragraphTextView.text = quizData.data?.body
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
                self.paragraphTextView.isScrollEnabled = true
            }
            self.goButton.setTitle("GO "+(quizData.data?.styleText ?? "")+" GO!", for: .normal)
            self.goButton.setTitleColor(UIColor.white, for: .normal)
        }else {
            if let quizData = HSUserManager.shared.currentUser?.quizData {
                if let code = quizData.color {
                let colorRecieved =  HSColorUtility.getMarkerTagColor(with: code)

                let heartRateImage = heartRateImageView?.image?.withRenderingMode(.alwaysTemplate)
                self.heartRateImageView.tintColor = colorRecieved
                self.heartRateImageView.image = heartRateImage

                self.goButton.backgroundColor = colorRecieved

                let quizBgImage = quizBackgroundImageView.image?.withRenderingMode(.alwaysTemplate)
                self.quizBackgroundImageView.tintColor = colorRecieved
                self.quizBackgroundImageView.image = quizBgImage

                let unStyledHeaderText = "YOU'RE A "+(quizData.styleText ?? "")+" IN HANDSTAND!"
                let attrs = [NSForegroundColorAttributeName:UIColor.black]
                let attrStr:NSMutableAttributedString = NSMutableAttributedString(string: unStyledHeaderText, attributes: attrs)
                attrStr.addAttribute(NSForegroundColorAttributeName,
                                     value: colorRecieved,
                                     range: NSRange.init(location: "YOU'RE A ".count, length: (quizData.styleText ?? "").count))
                self.topLabel.attributedText = attrStr
            }
            self.paragraphTextView.text = quizData.body
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
                self.paragraphTextView.isScrollEnabled = true
            }
            self.goButton.setTitle("GO "+(quizData.styleText ?? "")+" GO!", for: .normal)
            self.goButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }

}
