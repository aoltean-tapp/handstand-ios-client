//
//  HSQuizStyleSelectionCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSQuizStyleSelectionCellProtocol:class {
    func didTapChooseThisStyle(quiz:HSQuiz)
}

extension UIView {
     func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.cornerRadius = 5.0
    }
}

class HSQuizStyleSelectionCell: UICollectionViewCell,CellConfigurer {
    
    public weak var delegate:HSQuizStyleSelectionCellProtocol?
    
    @IBOutlet weak var styleHeaderLabel: UILabel!
    @IBOutlet weak var styleHeaderTopView: UIView! {
        didSet { styleHeaderTopView.layer.cornerRadius = 70/2 }
    }
    @IBOutlet weak var styleContentTextView: UITextView!
    private var handPickedQuiz:HSQuiz?

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        dropShadow()
    }
    
    @IBOutlet weak var chooseStyleButton: HSButton! {
        didSet { chooseStyleButton.btnType = .typeC }
    }
    
    public func populate(data:HSQuiz, index:Int) {
        handPickedQuiz = data
        styleHeaderLabel.text = index.description
        styleContentTextView.text = data.client?.quiz
        chooseStyleButton.btnType = data.isSelected ? .typeD : .typeC
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            self.styleContentTextView.isScrollEnabled = true
        }
    }
   
    @IBAction func didTapChooseThisStyle(_ sender: HSButton) {
        if let quiz = self.handPickedQuiz {
            sender.btnType = .typeD
            self.delegate?.didTapChooseThisStyle(quiz: quiz)
        }
    }
    
}
