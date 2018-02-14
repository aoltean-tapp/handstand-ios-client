//
//  HSOwnChatBubbleCellController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/14/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import Tapptitude
import SDWebImage

class HSOwnChatBubbleCellController: CollectionCellController<HSChatMessage, HSTrainerChatBubbleCell> {
    
    init() {
        super.init(cellSize: CGSize(width: -1.0, height: 103.0))
    }
    
    override func cellSize(for content: HSChatMessage, in collectionView: UICollectionView) -> CGSize {
        let cell = sizeCalculationCell!
        cell.frame.size = CGSize(width: collectionView.bounds.width, height: cellSize.height)
        configureCell(cell, for: content, at: IndexPath(row: 0, section: 0))
        cell.layoutIfNeeded()
        
        var size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        size.width = collectionView.bounds.width
        size.height = max(size.height, cellSize.height)
        cell.frame.size = size
        
        return size
    }
    
    override func configureCell(_ cell: HSTrainerChatBubbleCell, for content: HSChatMessage, at indexPath: IndexPath) {
        cell.trainerMessageLabel.text = content.message
    }
}
