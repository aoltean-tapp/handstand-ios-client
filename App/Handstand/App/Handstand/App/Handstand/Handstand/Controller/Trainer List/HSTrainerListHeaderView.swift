//
//  HSTrainerListHeaderView.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSTrainerListHeaderViewDelegate {
    func didClickedOnFilter()
}

class HSTrainerListHeaderView: UIView {
    
    var delegate : HSTrainerListHeaderViewDelegate? = nil

    //MARK:- Button Action
    
    @IBAction func onFilterAction(_ sender: UIButton) {
        delegate?.didClickedOnFilter()
    }
    

}
