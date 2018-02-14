//
//  HSChatCellController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/13/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import Tapptitude
import SDWebImage

class HSTrainerChatBubbleCellController: CollectionCellController<(String, HSChatMessage), HSTrainerChatBubbleCell> {
    
    init() {
        super.init(cellSize: CGSize(width: -1.0, height: 103.0))
    }
    
    override func cellSize(for content: (String, HSChatMessage), in collectionView: UICollectionView) -> CGSize {
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
    
    override func configureCell(_ cell: HSTrainerChatBubbleCell, for content: (String, HSChatMessage), at indexPath: IndexPath) {
        cell.trainerImageView.sd_setImage(with: URL(string: content.0), placeholderImage: #imageLiteral(resourceName: "icAvatarPlaceholder"))
        cell.trainerMessageLabel.text = content.1.message
    }
}
