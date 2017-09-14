//
//  CategoriesTableViewCell.swift
//  Dutch
//
//  Created by Apple on 25/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var productCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
