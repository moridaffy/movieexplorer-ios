//
//  PlaceholderTableViewCell.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class PlaceholderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.italicSystemFont(ofSize: 14.0)
    }
    
}
