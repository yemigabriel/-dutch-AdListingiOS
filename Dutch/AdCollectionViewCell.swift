//
//  AdCollectionViewCell.swift
//  Dutch
//
//  Created by Apple on 28/06/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adPrice: UILabel!
    @IBOutlet weak var adCategory: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//        if let attributes = layoutAttributes as? StaggeredLayoutAttributes {
//            imageHeightConstraint.constant = attributes.photoHeight - 100
//            //120 - annotations
//        }
//    }
    
    
}
