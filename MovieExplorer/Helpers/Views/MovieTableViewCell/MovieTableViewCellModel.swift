//
//  MovieTableViewCellModel.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 23/04/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

class MovieTableViewCellModel {
    let name: String
    let desc: String?
    let posterUrl: String?
    let backdropUrl: String?
    
    init(name: String, desc: String?, posterUrl: String? = nil, backdropUrl: String? = nil) {
        self.name = name
        self.desc = desc
        self.posterUrl = posterUrl
        self.backdropUrl = backdropUrl
    }
}
