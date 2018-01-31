//
//  HSQuizStyleSelectionCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSQuizStyleSelectionCellProtocol:class {
    func didTapChooseThisStyle(quiz:HSQuiz,sender:HSButton)
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
        didSet {
            styleHeaderTopView.layer.cornerRadius = 70/2
        }
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
    
    internal override func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.cornerRadius = 5.0
    }
    
    @IBOutlet weak var chooseStyleButton: HSButton! {
        didSet {
            chooseStyleButton.btnType = .typeC
        }
    }
    
    public func populate(data:HSQuiz, index:Int) {
        self.handPickedQuiz = data
//        self.styleHeaderLabel.text = data.client?.header
        self.styleHeaderLabel.text = index.description
        self.styleContentTextView.text = data.client?.quiz
    }
    
    @IBAction func didTapChooseThisStyle(_ sender: HSButton) {
        if let quiz = self.handPickedQuiz {
            self.delegate?.didTapChooseThisStyle(quiz: quiz,sender: sender)
        }
    }
    
}
