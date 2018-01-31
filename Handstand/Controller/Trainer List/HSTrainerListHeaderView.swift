//
//  HSTrainerListHeaderView.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSTrainerListHeaderViewDelegate:class {
    func didClickedOnFilter()
}

class HSTrainerListHeaderView: UIView {
    
   public weak var delegate : HSTrainerListHeaderViewDelegate? = nil

    //MARK:- Button Action
    @IBAction func onFilterAction(_ sender: UIButton) {
        delegate?.didClickedOnFilter()
    }
    
}
