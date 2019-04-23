//
//  MovieTableViewCell.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 28/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var blurEffectView: UIVisualEffectView!
    
    private var model: MovieTableViewCellModel!
    
    override func prepareForReuse() {
        posterImageView.image = nil
        backdropImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    func setup(model: MovieTableViewCellModel) {
        self.model = model
        setupContent()
    }
    
    private func setupStyle() {
        nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        descLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
    }
    
    private func setupContent() {
        nameLabel.text = model.name
        descLabel.text = model.desc
        
        if let posterUrl = model.posterUrl {
            posterImageView.kf.setImage(with: URL(string: APIManager.URLs.imageBaseUrl + posterUrl), placeholder: UIImage(named: "poster_placeholder"))
        }
        if let backdropUrl = model.backdropUrl {
            backdropImageView.kf.setImage(with: URL(string: APIManager.URLs.imageBaseUrl + backdropUrl))
        }
    }
    
}
