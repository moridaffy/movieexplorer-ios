//
//  MovieDetailsViewModel.swift
//  MovieExplorer
//
//  Created by Максим Скрябин on 23/04/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class MovieDetailsViewModel {
    let movie: Movie
    let titleArray = Variable([] as [String])
    let contentArray = Variable([] as [String])
    
    init(movie: Movie) {
        self.movie = movie
        
        var titleArray: [String] = []
        var contentArray: [String] = []
        
        if let tagline = movie.tagline {
            titleArray.append(NSLocalizedString("Tagline", comment: ""))
            contentArray.append(tagline)
        }
        if let desc = movie.desc {
            titleArray.append(NSLocalizedString("Description", comment: ""))
            contentArray.append(desc)
        }
        if let genre = movie.getGenresString() {
            titleArray.append(NSLocalizedString("Genre", comment: ""))
            contentArray.append(genre)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        titleArray.append(NSLocalizedString("Release date", comment: ""))
        contentArray.append(formatter.string(from: movie.date))
        titleArray.append(NSLocalizedString("User rating", comment: ""))
        contentArray.append("\(movie.vote) " + NSLocalizedString("из 10.0", comment: ""))
        titleArray.append(NSLocalizedString("Adult", comment: ""))
        contentArray.append(movie.adult ? NSLocalizedString("Yes", comment: "") : NSLocalizedString("No", comment: ""))
        
        guard titleArray.count == contentArray.count else { fatalError() }
        self.titleArray.value = titleArray
        self.contentArray.value = contentArray
    }
}
