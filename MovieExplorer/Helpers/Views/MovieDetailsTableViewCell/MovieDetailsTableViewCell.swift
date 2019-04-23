//
//  MovieDetailsTableViewCell.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 28/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var model: MovieDetailsTableViewCellModel!
    
    func setup(model: MovieDetailsTableViewCellModel) {
        self.model = model
        selectionStyle = .none
        
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        contentLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
    
}
