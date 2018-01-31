//
//  HSQuizStyleResultController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSQuizStyleResultController: HSBaseController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var heartRateImageView: UIImageView!
    @IBOutlet weak var paragraphTextView: UITextView!
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.dropShadow()
        }
    }
    @IBOutlet weak var goButton: UIButton!
    public var handpickedQuiz:HSQuizPostResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_12, viewController: self, titleView: getTitleView())
//        populateHandPickedQuizData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Selectors
    func didTapDoneButton() {
        HSAnalytics.setMixpanelPeopleConfiguration(HSUserManager.shared.currentUser!)
        HSAnalytics.setEventForTypes(withLog: HSA.createdAccount)
        HSApp().getAppFirstController({ (viewcontroller) in
            HSLoadingView.standardLoading().stopLoading()
            appDelegate.window?.rootViewController = viewcontroller
        })
    }
    
    //MARK: - Private functions
    private func populateHandPickedQuizData() {
        if let quizData = handpickedQuiz {
            self.topLabel.text = quizData.data?.header
            if let code = quizData.data?.colorAttribute?.code {
                let hash = abs(code.hashValue)
                let colorNum = hash % (256*256*256)
                let red = colorNum >> 16
                let green = (colorNum & 0x00FF00) >> 8
                let blue = (colorNum & 0x0000FF)
                topLabel.backgroundColor = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
            }else {
                topLabel.textColor = UIColor.black
            }
            self.paragraphTextView.text = quizData.data?.body
            self.goButton.setTitle(quizData.data?.footer, for: .normal)
        }
    }
    
}
